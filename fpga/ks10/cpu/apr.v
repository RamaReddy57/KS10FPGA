////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      APR Device
//!
//! \details
//!
//! \todo
//!
//! \file
//!      apr.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
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

`include "config.vh"
`include "useq/crom.vh"

module APR(clk, rst, clken, crom, dp, pwrINTR, nxmINTR, consINTR, aprFLAGS);

   parameter cromWidth = `CROM_WIDTH;

   input                   clk;         // Clock
   input                   rst;         // Reset
   input                   clken;       // Clock Enable
   input  [ 0:cromWidth-1] crom;        // Control ROM Data
   input  [ 0:35]          dp;         	// Data path
   input                   pwrINTR;     // Power Failure interrupt
   input                   nxmINTR;     // Non existant memory interrupt
   input                   consINTR;    // Console Interrupt
   output [22:35]          aprFLAGS;    // APR Flags

   //
   // Microcode Decode
   //

   wire specLOADAPR  = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADAPR);
   wire specAPRFLAGS = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_APRFLAGS);

   //
   // APR Flag Register 24
   //
   // Trace
   //  DPMB/E814
   //

   reg flag24;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag24 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag24 <= dp[24];
     end

   //
   // APR Flag Register 25
   //
   // Trace
   //  DPMB/E814
   //

   reg flag25;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag25 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag25 <= dp[25];
     end

   //
   // APR Flag Register 26
   //
   // Note
   //  On a KS10, this flag indicates that an power fail condition
   //  exists.
   //
   // Trace
   //  DPMB/E815
   //

   reg flagPWR;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagPWR <= 1'b0;
        else if (clken & specAPRFLAGS)
          if (pwrINTR)
            flagPWR <= 1'b1;
          else
            flagPWR <= dp[26];
     end

   //
   // APR Flag Register 27
   //
   // Note
   //  Non-existant memory interrupt.
   //
   // Trace
   //  DPMB/E815
   //

   reg flagNXM;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagNXM <= 1'b0;
        else if (clken & specAPRFLAGS)
          if (nxmINTR)
            flagNXM <= 1'b1;
          else
            flagNXM <= dp[27];
     end

   //
   // APR Flag Register 28
   //
   // Note
   //  On a KS10, this flag indicates that an uncorrectable memory
   //  error has occurred.   This is not implemented in the FPGA.
   //
   // Trace
   //  DPMB/E914
   //  DPMB/E915
   //

   reg flag28;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag28 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag28 <= dp[28];
     end

   //
   // APR Flag Register 29
   //
   // Note
   //  On a KS10, this flag indicates that an correctable memory
   //  error has occurred.   This is not implemented in the FPGA.
   //
   // Trace
   //  DPMB/E914
   //

   reg flag29;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag29 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag29 <= dp[29];
     end

   //
   // APR Flag Register 30
   //
   // Trace
   //  DPMB/E915
   //

   reg flag30;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flag30 <= 1'b0;
        else if (clken & specAPRFLAGS)
          flag30 <= dp[30];
     end

   //
   // APR Flag Register 31
   //
   // Note
   //  On a KS10, this flag indicates that a Console Interrupt
   //  has occurred.
   //
   // Trace
   //  DPMB/E915
   //

   reg flagCONS;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          flagCONS <= 1'b0;
        else if (clken & specAPRFLAGS)
          if (consINTR)
            flagCONS <= 1'b1;
          else
            flagCONS <= dp[31];
     end

   //
   // APR Enable Register
   //
   // Trace
   //  DPMB/E816
   //  DPMB/E916
   //  DPEB/E173
   //

   reg         flagTRAPEN;	// Trap Enable
   reg         flagPAGEEN;	// Paging Enable
   reg [24:31] flagAPREN;	// APR Enable
   reg         flagSWINT;	// Software Interrupt

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             flagTRAPEN <= 1'b0;
             flagPAGEEN <= 1'b0;
             flagAPREN  <= 8'b0;
             flagSWINT  <= 1'b0;
          end
        else if (clken & specLOADAPR)
          begin
             flagTRAPEN <= dp[22];
             flagPAGEEN <= dp[23];
             flagAPREN  <= dp[24:31];
             flagSWINT  <= dp[32];
          end
    end

   //
   // APR Interrupt Mask
   //
   // Details
   //  This masks the disabled interrupts.
   //
   // Trace
   //  DPMB/E817
   //  DPMB/E917
   //  DPMB/E121
   //  DPMB/E309
   //

   wire flagINTREQ = ((flag24   & flagAPREN[24]) ||
                      (flag25   & flagAPREN[25]) ||
                      (flagPWR  & flagAPREN[26]) ||
                      (flagNXM  & flagAPREN[27]) ||
                      (flag28   & flagAPREN[28]) ||
                      (flag29   & flagAPREN[29]) ||
                      (flag30   & flagAPREN[30]) ||
                      (flagCONS & flagAPREN[31]) ||
                      (flagSWINT));

   //
   // FIXUPS
   //

   assign aprFLAGS[22] = flagTRAPEN;
   assign aprFLAGS[23] = flagPAGEEN;
   assign aprFLAGS[24] = flag24;
   assign aprFLAGS[25] = flag25;
   assign aprFLAGS[26] = flagPWR;
   assign aprFLAGS[27] = flagNXM;
   assign aprFLAGS[28] = flag28;
   assign aprFLAGS[29] = flag29;
   assign aprFLAGS[30] = flag30;
   assign aprFLAGS[31] = flagCONS;
   assign aprFLAGS[32] = flagINTREQ;
   assign aprFLAGS[33] = 1'b1;
   assign aprFLAGS[34] = 1'b1;
   assign aprFLAGS[35] = 1'b1;

endmodule
