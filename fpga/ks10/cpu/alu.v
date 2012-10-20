////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      AM2901 ALU
//!
//! \details
//!
//! \note
//!      The KS10 ALU implementation uses ten cascaded am2901 4-bit
//!      slices.  Some quick study showed that this did not work
//!      well with an FPGA implemenation.  Most FPGAs have optimized
//!      (very fast) carry logic to support counters and adders.  It
//!      turns out that the synthesis tools can't infer from the
//!      description of the 4-bit slices that a single 40-bit carry
//!      chain exists from the LSB to the MSB.  Therefore this ALU
//!      is implemented as two 20-bit ALUs.   The two 20-bit ALUs
//!      are required because the two ALU halves must operate
//!      together forming a single 40-bit ALU and must operate
//!      separately to form two independant registers.
//!
//! \note
//!      The ALU bit numbering on the schematic is [-2,-1,0,1:37].
//!      This doesn't work at all for verilog.   Therefore the
//!      bit numbering is [0:39].
//!
//! \file
//!      alu.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////
//
// Comments are formatted for doxygen
//

`include "microcontroller/crom.vh"

module ALU(clk, rst, clken, dbus, crom,
           aluLZero, aluRZero, aluLSign, aluRSign,
           aluAOV, aluCRY0, aluCRY1, aluCRY2,
           aluQR37, t);

   parameter cromWidth = `CROM_WIDTH;

   input                  clk;                  // Clock
   input                  rst;                  // Reset
   input                  clken;                // Clock enable
   input  [0:35]          dbus;                 // Bus input
   input  [0:cromWidth-1] crom;                 // Control ROM Data
   output                 aluLZero;             // ALU left half Zero
   output                 aluRZero;             // ALU right half Zero
   output                 aluLSign;             // ALU left half Sign
   output                 aluRSign;             // ALU right half Sign
   output                 aluAOV;               // ALU Arithmetic Overflow
   output                 aluCRY0;              // ALU Carry 0
   output                 aluCRY1;              // ALU Carry 1
   output                 aluCRY2;              // ALU Carry 2
   output                 aluQR37;		// ALU QR37
   output [0:35]          t;                    // ALU Output

   //
   // Microcode fields
   //  These temporaries are created so I can see the microcode fields
   //  in the simulator.  The synthesis optimizer deletes them.
   //

   reg  [0:39] f;                               // ALU Output
   reg  [0:39] q;                               // Q Register Output
   wire [0: 2] fun     = `cromFUN;              // ALU Function
   wire [0: 2] lsrc    = `cromLSRC;             // ALU Source (Left Side)
   wire [0: 2] rsrc    = `cromRSRC;             // ALU Source (Right Size)
   wire [0: 2] dst     = `cromDST;              // ALU Destination
   wire        lclken  = `cromLCLKEN;           // ALU CLock (Left Side)
   wire        rclken  = `cromRCLKEN;           // ALU Clock (Right Side)
   wire [0: 3] aa      = `cromALU_A;            // ALU DPRAM A Address
   wire [0: 3] ba      = `cromALU_B;            // ALU DPRAM B Address
   wire [0: 2] shstyle = `cromSPEC_SHSTYLE;     // ALU Shift Mode
   wire cry18inh       = `cromSPEC_SEL_CRY18INH;// Inhibit carry from right half to left half

   //
   // DST[1] is inverted on DPE5/E62
   //  Note on the am2901's during shifts, the dst[1] pin
   //  selects right shifts from left shifts.  In the KS10,
   //  the dst[1] also selects tri-state muxes for attaching
   //  the right-shift and left-shift operations.  This isn't
   //  necessary on the FPGA implementation, because this
   //  version of the am2901 doesn't have tri-stated inputs.
   //

   wire [0:2] dest = {dst[0], ~dst[1], dst[2]};

   //
   // FUN[2] is munged on DPE5
   //  Note on the am2901's, when fun[0] and fun[1] are both
   //  zero, fun[2] selects between add and subract ops.
   //  This is used in the divide and multiprecision ops.
   //

   wire [0:2] func = {fun[0], fun[1], funct_02};

   //
   // In the KS10, the ALU is 40-bits wide.  Sign extend input
   // from 36 bits to 38 bits and add two bits padding on right.
   //

   wire [0:39] dd = {dbus[0], dbus[0], dbus[0:35], 2'b00};

   //
   // Shifter Operations:
   //  The am2901s are wired together to perform specific shift
   //  operation controlled by the cromSPEC_SHSTYLE microcode
   //  field.  The ASCII art pictures below detail the various
   //  shifter modes.
   //
   //  Shift Left Operations
   //
   //            +--------- F shifter --------+      +--------- Q shifter --------+
   //            |                            |      |                            |
   //
   //                                   multi_shift
   //                                        |
   //             +----+       +----------+  |         +----+       +----------+
   //  NORM       |0123|<------|4       39|<-+         |0123|<------|4       39|<---- 0
   //             +----+       +----------+            +----+       +----------+
   //
   //              +------+
   //              |      |
   //             +----+  |    +----------+            +----+       +----------+
   //  ZER0       |0123|<-+    |4       39|<---- 0     |0123|<------|4       39|<---- 0
   //             +----+       +----------+            +----+       +----------+
   //
   //              +------+
   //              |      |
   //             +----+  |    +----------+            +----+       +----------+
   //  ONES       |0123|<-+    |4       39|<---- 1     |0123|<------|4       39|<---- 1
   //             +----+       +----------+            +----+       +----------+
   //
   //              +------+  +---------------+                    +---------------+
   //              |      |  |               |                    |               |
   //             +----+  |  | +----------+  |         +----+     | +----------+  |
   //  ROT        |0123|<-+  +-|4       39|<-+         |0123|<----+-|4       39|<-+
   //             +----+       +----------+            +----+       +----------+
   //
   //              +------+
   //              |      |
   //             +----+  |    +----------+            +----+       +----------+
   //  ASHC       |0123|<-+    |4       39|<----+      |0123|<----+-|4       39|<---- 0
   //             +----+       +----------+     |      +----+     | +----------+
   //                                           |                 |
   //                                           +-----------------+
   //
   //             +----+       +----------+            +----+       +----------+
   //  LSHC       |0123|<------|4       39|<----+      |0123|<----+-|4       39|<---- 0
   //             +----+       +----------+     |      +----+     | +----------+
   //                                           |                 |
   //                                           +-----------------+
   //
   //             +----+       +----------+            +----+       +----------+
   //  DIV        |0123|<------|4       39|<----+      |0123|<----+-|4       39|<---- divide_shift
   //             +----+       +----------+     |      +----+     | +----------+
   //                                           |                 |
   //                                           +-----------------+
   //
   //              +------+  +----------------------------------------------------+
   //              |      |  |                                                    |
   //             +----+  |  | +----------+            +----+       +----------+  |
   //  ROTC       |0123|<-+  +-|4       39|<----+      |0123|<----+-|4       39|<-+
   //             +----+       +----------+     |      +----+     | +----------+
   //                                           |                 |
   //                                           +-----------------+
   //
   //  Shift Right Operations
   //
   //            +--------- F shifter --------+      +--------- Q shifter --------+
   //            |                            |      |                            |
   //
   //          +---+                                0
   //          |   |                                |
   //          |  +----+       +----------+         |  +----+       +----------+
   //  NORM    +->|0123|------>|4       39|         +->|0123|------>|4       39|
   //             +----+       +----------+            +----+       +----------+
   //
   //          +---+        0                       0            0
   //          |   |        |                       |            |
   //          |  +----+    |  +----------+         |  +----+    |  +----------+
   //  ZEROS   +->|0123|    +->|4       39|         +->|0123|    +->|4       39|
   //             +----+       +----------+            +----+       +----------+
   //
   //          +---+        1                       0            1
   //          |   |        |                       |            |
   //          |  +----+    |  +----------+         |  +----+    |  +----------+
   //  ONES    +->|0123|    +->|4       39|         +->|0123|    +->|4       39|
   //             +----+       +----------+            +----+       +----------+
   //
   //          +---+        +---------------+       0            +---------------+
   //          |   |        |               |       |            |               |
   //          |  +----+    |  +----------+ |       |  +----+    |  +----------+ |
   //  ROT     +->|0123|    +->|4       39|-+       +->|0123|    +->|4       39|-+
   //             +----+       +----------+            +----+       +----------+
   //
   //          +---+                                0
   //          |   |                                |
   //          |  +----+       +----------+         |  +----+       +----------+
   //  ASHC    +->|0123|------>|4       39|-----+   +->|0123|    +->|4       39|
   //             +----+       +----------+     |      +----+    |  +----------+
   //                                           |                |
   //                                           +----------------+
   //
   //          +---+        0                       0
   //          |   |        |                       |
   //          |  +----+    |  +----------+         |  +----+       +----------+
   //  LSHC    +->|0123|    +->|4       39|-----+   +->|0123|    +->|4       39|
   //             +----+       +----------+     |      +----+    |  +----------+
   //                                           |                |
   //                                           +----------------+
   //
   //          +---+        1                       0
   //          |   |        |                       |
   //          |  +----+    |  +----------+         |  +----+       +----------+
   //  DIV     +->|0123|    +->|4       39|-----+   +->|0123|    +->|4       39|
   //             +----+       +----------+     |      +----+    |  +----------+
   //                                           |                |
   //                                           +----------------+
   //
   //          +---+        +----------------------------------------------------+
   //          |   |        |                       0                            |
   //          |  +----+    |  +----------+         |  +----+       +----------+ |
   //  ROTC    +->|0123|    +->|4       39|-----+   +->|0123|    +->|4       39|-+
   //             +----+       +----------+     |      +----+    |  +----------+
   //                                           |                |
   //                                           +----------------+
   // DPE1/E12
   // DPE1/E20
   // DPE1/E41
   // DPE1/E48
   // DPE1/E71
   //

   reg [0:39] bdi;
   always @(f or q or dest or shstyle or multi_shift)
     begin
        if (dest == `cromDST_RAMQU || dest == `cromDST_RAMU)
          case (shstyle)
            `cromSPEC_SHSTYLE_NORM:
              bdi = {f[1:3], f[4], f[5:39], multi_shift};
            `cromSPEC_SHSTYLE_ZERO:
              bdi = {f[1:3], f[0], f[5:39], 1'b0};
            `cromSPEC_SHSTYLE_ONES:
              bdi = {f[1:3], f[0], f[5:39], 1'b1};
            `cromSPEC_SHSTYLE_ROT:
              bdi = {f[1:3], f[0], f[5:39], f[4]};
            `cromSPEC_SHSTYLE_ASHC:
              bdi = {f[1:3], f[0], f[5:39], q[4]};
            `cromSPEC_SHSTYLE_LSHC:
              bdi = {f[1:3], f[4], f[5:39], q[4]};
            `cromSPEC_SHSTYLE_DIV:
              bdi = {f[1:3], f[4], f[5:39], q[4]};
            `cromSPEC_SHSTYLE_ROTC:
              bdi = {f[1:3], f[0], f[5:39], q[4]};
          endcase
        else if (dest == `cromDST_RAMQD ||  dest == `cromDST_RAMD)
          case (shstyle)
            `cromSPEC_SHSTYLE_NORM:
              bdi = {f[0], f[0:2], f[3],  f[4:38]};
            `cromSPEC_SHSTYLE_ZERO:
              bdi = {f[0], f[0:2], 1'b0,  f[4:38]};
            `cromSPEC_SHSTYLE_ONES:
              bdi = {f[0], f[0:2], 1'b1,  f[4:38]};
            `cromSPEC_SHSTYLE_ROT:
              bdi = {f[0], f[0:2], f[39], f[4:38]};
            `cromSPEC_SHSTYLE_ASHC:
              bdi = {f[0], f[0:2], f[3],  f[4:38]};
            `cromSPEC_SHSTYLE_LSHC:
              bdi = {f[0], f[0:2], 1'b0,  f[4:38]};
            `cromSPEC_SHSTYLE_DIV:
              bdi = {f[0], f[0:2], 1'b1,  f[4:38]};
            `cromSPEC_SHSTYLE_ROTC:
              bdi = {f[0], f[0:2], q[39], f[4:38]};
          endcase
        else
          bdi = f;
     end

   //
   // Left Half (MS) Register File
   //

   integer i;
   reg [0:19] RAML [0:15];
   wire wrl = ((dest ==`cromDST_RAMA) || (dest ==`cromDST_RAMF) || (dest ==`cromDST_RAMQD) ||
               (dest ==`cromDST_RAMD) || (dest ==`cromDST_RAMU) || (dest ==`cromDST_RAMQU));

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          for (i = 0; i < 16; i = i + 1)
            RAML[i] <= 20'b0;
        else if (clken & lclken & wrl)
          RAML[ba] <= bdi[0:19];
     end

   //
   // Right Half (LS) Register File
   //

   integer j;
   reg [0:19] RAMR [0:15];
   wire wrr = ((dest ==`cromDST_RAMA) || (dest ==`cromDST_RAMF) || (dest ==`cromDST_RAMQD) ||
               (dest ==`cromDST_RAMD) || (dest ==`cromDST_RAMU) || (dest ==`cromDST_RAMQU));

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          for (j = 0; j < 16; j = j + 1)
            RAMR[j] <= 20'b0;
        else if (clken & rclken && wrr)
          RAMR[ba] <= bdi[20:39];
     end

   wire [0:39] ad = {RAML[aa], RAMR[aa]};
   wire [0:39] bd = {RAML[ba], RAMR[ba]};

   //
   // Q Register Shifter
   //

   reg [0:39] qi;
   always @(f or q or dest or shstyle or divide_shift)
     begin
        case (dest)
         `cromDST_RAMQU:
            case (shstyle)
              `cromSPEC_SHSTYLE_NORM:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_ZERO:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_ONES:
                qi <= {q[1:39], 1'b1};
              `cromSPEC_SHSTYLE_ROT:
                qi <= {q[1:39], q[4]};
              `cromSPEC_SHSTYLE_ASHC:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_LSHC:
                qi <= {q[1:39], 1'b0};
              `cromSPEC_SHSTYLE_DIV:
                qi <= {q[1:39], divide_shift};
              `cromSPEC_SHSTYLE_ROTC:
                qi <= {q[1:39], f[4]};
            endcase
         `cromDST_RAMQD:
            case (shstyle)
              `cromSPEC_SHSTYLE_NORM:
                qi <= {1'b0, q[0:2], q[3],  q[4:38]};
              `cromSPEC_SHSTYLE_ZERO:
                qi <= {1'b0, q[0:2], 1'b0,  q[4:38]};
              `cromSPEC_SHSTYLE_ONES:
                qi <= {1'b0, q[0:2], 1'b1,  q[4:38]};
              `cromSPEC_SHSTYLE_ROT:
                qi <= {1'b0, q[0:2], q[39], q[4:38]};
              `cromSPEC_SHSTYLE_ASHC:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_LSHC:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_DIV:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
              `cromSPEC_SHSTYLE_ROTC:
                qi <= {1'b0, q[0:2], f[39], q[4:38]};
            endcase
         `cromDST_QREG:
            qi <= f;
          default:
            qi <= q;
        endcase
     end

   //
   // Left Half Q Register
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          q[0:19] <= 20'b0;
        else if (clken & lclken)
          q[0:19] <= qi[0:19];
     end

   //
   // Right Half Q Register
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          q[20:39] <= 20'b0;
        else if (clken & rclken)
          q[20:39] <= qi[20:39];
     end

   //
   // ALU Left R Source Selector
   //

   reg [0:39] r;
   always @(ad or dd or lsrc)
     begin
        case (lsrc)
          `cromSRC_AQ:
            r[0:19] = ad[0:19];
          `cromSRC_AB:
            r[0:19] = ad[0:19];
          `cromSRC_ZQ:
            r[0:19] = 20'b0;
          `cromSRC_ZB:
            r[0:19] = 20'b0;
          `cromSRC_ZA:
            r[0:19] = 20'b0;
          default:
            r[0:19] = dd[0:19];
        endcase
     end

   //
   // ALU Right R Source Selector
   //

   always @(ad or dd or rsrc)
     begin
        case (rsrc)
          `cromSRC_AQ:
            r[20:39] = ad[20:39];
          `cromSRC_AB:
            r[20:39] = ad[20:39];
          `cromSRC_ZQ:
            r[20:39] = 20'b0;
          `cromSRC_ZB:
            r[20:39] = 20'b0;
          `cromSRC_ZA:
            r[20:39] = 20'b0;
          default:
            r[20:39] = dd[20:39];
        endcase
     end

   //
   // ALU Left S Source Selector
   //

   reg [0:39] s;
   always @(ad or bd or q or lsrc)
     begin
        case (lsrc)
          `cromSRC_AQ:
            s[0:19] = q[0:19];
          `cromSRC_ZQ:
            s[0:19] = q[0:19];
          `cromSRC_DQ:
            s[0:19] = q[0:19];
          `cromSRC_AB:
            s[0:19] = bd[0:19];
          `cromSRC_ZB:
            s[0:19] = bd[0:19];
          `cromSRC_ZA:
            s[0:19] = ad[0:19];
          `cromSRC_DA:
            s[0:19] = ad[0:19];
          default:
            s[0:19] = 20'b0;
        endcase
     end

   //
   // ALU Right S Source Selector
   //

   always @(ad or bd or q or rsrc)
     begin
        case (rsrc)
          `cromSRC_AQ:
            s[20:39] = q[20:39];
          `cromSRC_ZQ:
            s[20:39] = q[20:39];
          `cromSRC_DQ:
            s[20:39] = q[20:39];
          `cromSRC_AB:
            s[20:39] = bd[20:39];
          `cromSRC_ZB:
            s[20:39] = bd[20:39];
          `cromSRC_ZA:
            s[20:39] = ad[20:39];
          `cromSRC_DA:
            s[20:39] = ad[20:39];
          default:
            s[20:39] = 20'b0;
        endcase
     end

   //
   // ALU Proper
   //  The ALU is somewhat optimized so that the carry chain can
   //  be optimized.  Instead of adding logic into the middle of
   //  of the carry to separate the left half and the right half
   //  of the ALU, the left half, the right half, and the whole
   //  ALU are calculated in parallel.
   //

   reg [0:3] g;				// ALU Partial Sum
   reg       co;                        // Carry out of left half
   reg       go;                        // Partial sum for calculating CRY2
   wire      ci  = carry_in;            // Carry into left half
   reg       bb;			// Bit Bucket
   

   always @(r or s or ci or cry18inh or func)
     begin
        co  = 1'b0;
        go  = 1'b0;
        g   = 4'b0;
        case (func)
          `cromFUN_ADD:
            begin
               {go, g[ 0: 3]} = {1'b0, r[ 0: 3]} + {1'b0, s[ 0: 3]};
               if (cry18inh)
                 begin
                    {bb, f[20:39]} = {1'b0, r[20:39]} + {1'b0, s[20:39]} + ci;      	// Right Half
                    {co, f[ 0:19]} = {1'b0, r[ 0:19]} + {1'b0, s[ 0:19]};     		// Left Half (assumes no carry)
                 end
               else
                 begin
                    {co, f[ 0:39]} = {1'b0, r[ 0:39]} + {1'b0, s[ 0:39]} + ci;      	// Whole ACC
                 end
            end
          `cromFUN_SUBR:
            begin
               {go, g[ 0: 3]} = {1'b1, ~r[ 0: 3]} + {1'b0, s[ 0: 3]};
               if (cry18inh)
                 begin
                    {bb, f[20:39]} = {1'b1, ~r[20:39]} + {1'b0, s[20:39]} + ci;     	// Right Half
                    {co, f[ 0:19]} = {1'b1, ~r[ 0:19]} + {1'b0, s[ 0:19]};    		// Left Half (assumes no carry)
                 end
               else
                 begin
                    {co, f[ 0:39]} = {1'b1, ~r[ 0:39]} + {1'b0, s[ 0:39]} + ci;      	// Whole ACC
                 end
            end
          `cromFUN_SUBS:
            begin
               {go, g[ 0: 3]} = {1'b0, r[ 0: 3]} + {1'b1, ~s[ 0: 3]};
               if (cry18inh)
                 begin
                    {bb, f[20:39]} = {1'b0, r[20:39]} + {1'b1, ~s[20:39]} + ci;     	// Right Half
                    {co, f[ 0:19]} = {1'b0, r[ 0:19]} + {1'b1, ~s[ 0:19]};    		// Left Half (assumes no carry)
                 end
               else
                 begin
                    {co, f[ 0:39]} = {1'b0, r[ 0:39]} + {1'b1, ~s[ 0:39]} + ci;      	// Whole ACC
                 end
            end
          `cromFUN_ORRS:
            f = r | s;
          `cromFUN_ANDRS:
            f = r & s;
          `cromFUN_NOTRS:
            f = ~r & s;
          `cromFUN_EXOR:
            f = r ^ s;
          `cromFUN_EXNOR:
            f = ~(r ^ s);
        endcase
     end

   //
   // ALU Sign outputs
   //

   assign aluLSign = f[ 0];
   assign aluRSign = f[20];

   //
   // ALU Zero outputs
   //

   assign aluLZero = f[ 0:19] == 20'b0;
   assign aluRZero = f[20:39] == 20'b0;

   //
   // aluAOV
   //  DPE9/E26
   //

   assign aluAOV = aluLSign != f[2];

   //
   // aluCRY0
   //  This is the carry form ALU bit -2 (Verilog bit 0).
   //  In this KS10, this signal comes from the carry skippers,
   //  which doesn't work well with an FPGA implementation. In
   //  this implementation, 'co' signal comes directly from
   //  the ALU calculation.
   //
   //  Technically, this should be aluCRY(-2).  See usage in
   //  microcode.
   //

   assign aluCRY0 = co;

   //
   // aluCRY1
   //  DPE9/E26
   //

   assign aluCRY1 = aluAOV != aluCRY0;

   // aluCRY2:
   //  This is the carry from ALU bit 2 into ALU bit 1.  In
   //  Verilog numbering (see notes at top of file), this is a
   //  carry from ALU bit 4 into ALU bit 3.   We don't really
   //  have access to the carry from ALU bit 4, but we infer
   //  it by recalculating the 4 MSBs with the carry cleared,
   //  and checking to see if it yields the same results as
   //  the full calculation.
   //

   assign aluCRY2 = ((go != co) | (f[0:3] != g[0:3]));

   //
   // FLAG Logic
   //  DPE5/E4
   //  DPE5/E5
   //  DPE5/E6
   //  DPE5/E62
   //  DPE5/E70
   //

   wire carry_in = ((flag_carry_02  & `cromMULTIPREC) |
                    (flag_carry_out & `cromDIVIDE   ) |
                    (`cromCRY38));

   wire funct_02 = ((flag_funct_02  & `cromMULTIPREC) |
                    (flag_carry_out & `cromDIVIDE   ) |
                    (fun[2]));

   //
   // Flag Register
   //  DPE5/E28
   //

   reg flag_fl02;
 //reg flag_ql02;
   reg flag_qr37;
   reg flag_carry_02;
   reg flag_funct_02;
   reg flag_carry_out;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             flag_fl02      <= 1'b0;
           //flag_ql02      <= 1'b0;
             flag_qr37      <= 1'b0;
             flag_carry_02  <= 1'b0;
             flag_funct_02  <= 1'b0;
             flag_carry_out <= 1'b0;
          end
        else
          begin
             flag_fl02      <= bdi[4];
           //flag_ql02      <= qi[4];
             flag_qr37      <= qi[39];
             flag_carry_02  <= aluCRY2;
             flag_funct_02  <= funct_02;
             flag_carry_out <= aluCRY0;
         end
     end

   assign aluQR37 = flag_qr37;
   
   //
   //
   // DPE5/E4
   // DPE5/E6
   // DPE5/E62
   // DPE5/E70
   //

   wire multi_shift  = flag_fl02   & `cromMULTIPREC;
   wire divide_shift = `cromDIVIDE & flag_carry_out;

   //
   // ALU Destination Selector
   //  Select ALU output and truncate output bus from 40 bits
   //  to 36 bits.
   //

   assign t = (dest ==`cromDST_RAMA) ? ad[2:37] : f[2:37];

endmodule