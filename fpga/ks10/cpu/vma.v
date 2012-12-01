////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Virtual Memory Address
//!
//! \details
//!
//! \todo
//!
//! \file
//!      vma.v
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

`default_nettype none
`include "useq/crom.vh"
`include "useq/drom.vh"

module VMA(clk, rst, clken, crom, drom, dp, cpuEXEC, prevEN, pcFLAGS,
           vmaEXTENDED, vmaFLAGS, vmaADDR);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;

   input                   clk;         // Clock
   input                   rst;         // Reset
   input                   clken;       // Clock Enable
   input  [ 0:cromWidth-1] crom;        // Control ROM Data
   input  [ 0:dromWidth-1] drom;        // Dispatch ROM Data
   input  [ 0:35]          dp;          // Data path
   input                   cpuEXEC;     // Execute
   input                   prevEN;      // Previous Enable
   input  [ 0:17]          pcFLAGS;     // PC Flags
   output                  vmaEXTENDED; // VMA Extended
   output [ 0:13]          vmaFLAGS;    // VMA Flags
   output [14:35]          vmaADDR;     // Virtual Memory Address

   //
   // PC Flags
   //

   wire flagUSER = pcFLAGS[5];          // User
   wire flagPCU  = pcFLAGS[6];          // Previous Context User

   //
   // Microcode Decode
   //
   // Note
   //  The cache clear and the previous selection are exclusive
   //  operations.
   //
   // Trace
   //  DPE5/E76
   //  DPE6/E53
   //

   wire cacheSWEEP  = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRCACHE);
   wire selPREVIOUS = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_PREVIOUS);

   //
   // VMA Register
   //
   // Trace
   //  DPE3/E53
   //  DPM4/E55
   //  DPM4/E56
   //  DPM4/E74
   //  DPE3/E76
   //  DPM4/E82
   //  DPM4/E90
   //  DPM4/E97
   //  DPM4/E103
   //  DPM4/E115
   //  DPM4/E137
   //  DPM4/E152
   //  DPM4/E168
   //  DPM4/E175
   //  DPM4/E182
   //  DPM4/E183
   //

   reg [14:35] vmaADDR;
   reg vmaEXTENDED;
   reg vmaUSER;
   reg vmaFETCH;
   reg vmaPHYSICAL;
   reg vmaPREVIOUS;
   reg vmaIOCYCLE;
   reg vmaWRUCYCLE;
   reg vmaVECTORCYCLE;
   reg vmaIOBYTECYCLE;

   wire vmaEN = ((`cromMEM_CYCLE & `cromMEM_LOADVMA           ) |
                 (`cromMEM_CYCLE & `cromMEM_AREAD   & `dromVMA) |
                 (cacheSWEEP));

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             vmaADDR        <= 22'b0;
             vmaEXTENDED    <=  1'b0;
             vmaUSER        <=  1'b0;
             vmaFETCH       <=  1'b0;
             vmaPHYSICAL    <=  1'b0;
             vmaPREVIOUS    <=  1'b0;
             vmaIOCYCLE     <=  1'b0;
             vmaWRUCYCLE    <=  1'b0;
             vmaVECTORCYCLE <=  1'b0;
             vmaIOBYTECYCLE <=  1'b0;
          end
        else if (clken & vmaEN)
          begin
             vmaADDR     <= dp[14:35];
             vmaEXTENDED <= `cromMEM_EXTADDR;
             if (`cromMEM_DPFUNC)
               begin
                  vmaUSER        <= dp[0];
                  vmaFETCH       <= dp[2];
                  vmaPHYSICAL    <= dp[8];
                  vmaPREVIOUS    <= dp[9];
                  vmaIOCYCLE     <= dp[10];
                  vmaWRUCYCLE    <= dp[11];
                  vmaVECTORCYCLE <= dp[12];
                  vmaIOBYTECYCLE <= dp[13];
               end
             else
               begin
                  vmaUSER        <= ((~`cromMEM_FORCEEXEC & flagUSER & ~cpuEXEC) |
                                     (`cromMEM_FETCHCYCLE & flagUSER           ) |
                                     (prevEN              & flagPCU            ) |
                                     (selPREVIOUS         & flagPCU            ) |
                                     (`cromMEM_FORCEUSER));
                  vmaFETCH       <= `cromMEM_FETCHCYCLE;
                  vmaPHYSICAL    <= `cromMEM_PHYSICAL;
                  vmaPREVIOUS    <= prevEN | selPREVIOUS;
                  vmaIOCYCLE     <= 1'b0;
                  vmaWRUCYCLE    <= 1'b0;
                  vmaVECTORCYCLE <= 1'b0;
                  vmaIOBYTECYCLE <= 1'b0;
               end
          end
    end

   //
   // Memory Cycle Control
   //
   // Details
   //  The type of memory cycle can controlled by the microcode or
   //  can be controlled by the Dispatch ROM.
   //
   // Trace
   //  DPM5/E48
   //  DPM5/E66
   //  DPM5/E33
   //  DPM5/E110
   //

   reg vmaREADCYCLE;
   reg vmaWRTESTCYCLE;
   reg vmaWRITECYCLE;
   reg vmaCACHEINH;

   wire memEN = ((`cromMEM_CYCLE  & `cromMEM_WAIT                   ) |
                 (`cromMEM_CYCLE  & `cromMEM_BWRITE & `dromCOND_FUNC));

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             vmaREADCYCLE   <= 1'b0;
             vmaWRTESTCYCLE <= 1'b0;
             vmaWRITECYCLE  <= 1'b0;
             vmaCACHEINH    <= 1'b0;
          end
        else if (clken & memEN)
          begin
             if (`cromMEM_AREAD)
               begin
                  vmaREADCYCLE   <= `dromREADCYCLE;
                  vmaWRTESTCYCLE <= `dromWRTESTCYCLE;
                  vmaWRITECYCLE  <= `dromWRITECYCLE;
                  vmaCACHEINH    <= 1'b0;
               end
             else
               if (`cromMEM_DPFUNC)
                 begin
                    vmaREADCYCLE   <= dp[3];
                    vmaWRTESTCYCLE <= dp[4];
                    vmaWRITECYCLE  <= dp[5];
                    vmaCACHEINH    <= dp[7];
                 end
               else
                 begin
                    vmaREADCYCLE   <= `cromMEM_READCYCLE;
                    vmaWRTESTCYCLE <= `cromMEM_WRTESTCYCLE;
                    vmaWRITECYCLE  <= `cromMEM_WRITECYCLE;
                    vmaCACHEINH    <= `cromMEM_CACHEINH;
                 end
          end
     end

   //
   // Fixup vmaFLAGS
   //

   assign vmaFLAGS[ 0] = vmaUSER;
   assign vmaFLAGS[ 1] = 1'b0;
   assign vmaFLAGS[ 2] = vmaFETCH;
   assign vmaFLAGS[ 3] = vmaREADCYCLE;
   assign vmaFLAGS[ 4] = vmaWRTESTCYCLE;
   assign vmaFLAGS[ 5] = vmaWRITECYCLE;
   assign vmaFLAGS[ 6] = 1'b0;
   assign vmaFLAGS[ 7] = vmaCACHEINH;
   assign vmaFLAGS[ 8] = vmaPHYSICAL;
   assign vmaFLAGS[ 9] = vmaPREVIOUS;
   assign vmaFLAGS[10] = vmaIOCYCLE;
   assign vmaFLAGS[11] = vmaWRUCYCLE;
   assign vmaFLAGS[12] = vmaVECTORCYCLE;
   assign vmaFLAGS[13] = vmaIOBYTECYCLE;

endmodule
