////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   DZ11 Control and Status Register (CSR)
//
// Details
//   The module implements the DZ11 CSR Register.
//
// File
//   dzcsr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2014 Rob Doyle
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; version 2.1 of the License.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`include "dzcsr.vh"
`include "dztcr.vh"
`include "../../ks10.vh"

  module DZCSR(clk, rst,
               devRESET, devLOBYTE, devHIBYTE, devDATAI, csrWRITE, tdrWRITE,
               scan, rbufRDONE, rbufSA, uartTXEMPTY, regTCR, regCSR);

   input          clk;                          // Clock
   input          rst;                          // Reset
   input          devRESET;                     // Device Reset from UBA
   input          devLOBYTE;                    // Device Low Byte
   input          devHIBYTE;                    // Device High Byte
   input  [ 0:35] devDATAI;                     // Device Data In
   input          csrWRITE;                     // Write to CSR
   input          tdrWRITE;                     // Write to TDR
   input  [ 2: 0] scan;                         // Scanner
   input          rbufRDONE;                    // RBUF Receiver Done
   input          rbufSA;                       // RBUF Silo Alarm
   input  [ 7: 0] uartTXEMPTY;                  // UART transmitter buffer empty
   input  [15: 0] regTCR;                       // TCR Register
   output [15: 0] regCSR;                       // CSR Output

   //
   // Big-endian to little-endian data bus swap
   //

   wire [35:0] dzDATAI = devDATAI[0:35];

   //
   // TCR[LIN] bits
   //

   wire [ 7:0] tcrLIN  = `dzTCR_LIN(regTCR);

   //
   // Clear
   //
   // Details
   //    //  The CSR[CLR] is a 15us one-shot in the KS10
   //

   reg [9:0] clrCOUNT;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          clrCOUNT <= 0;
        else
          begin
             if (devRESET)
               clrCOUNT <= 0;
             if (csrWRITE & devLOBYTE & `dzCSR_CLR(dzDATAI))
               clrCOUNT <= 15 * `CLKFRQ / 1000000;
             else if (clrCOUNT != 0)
               clrCOUNT <= clrCOUNT - 1'b1;
          end
     end

   wire csrCLR = (clrCOUNT != 0);

   //
   // CSR Read/Write bits
   //
   // Details
   //  These bits can be written as bytes or words.
   //

   reg csrTIE;
   reg csrSAE;
   reg csrRIE;
   reg csrMSE;
   reg csrMAINT;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             csrTIE   <= 0;
             csrSAE   <= 0;
             csrRIE   <= 0;
             csrMSE   <= 0;
             csrMAINT <= 0;
          end
        else
          begin
             if (csrCLR | devRESET)
               begin
                  csrTIE   <= 0;
                  csrSAE   <= 0;
                  csrRIE   <= 0;
                  csrMSE   <= 0;
                  csrMAINT <= 0;
               end
             else if (csrWRITE)
               begin
                  if (devHIBYTE)
                    begin
                       csrTIE   <= `dzCSR_TIE(dzDATAI);
                       csrSAE   <= `dzCSR_SAE(dzDATAI);
                    end
                  if (devLOBYTE)
                    begin
                       csrRIE   <= `dzCSR_RIE(dzDATAI);
                       csrMSE   <= `dzCSR_MSE(dzDATAI);
                       csrMAINT <= `dzCSR_MAINT(dzDATAI);
                    end
               end
          end
     end

   //
   // Transmitter Scanner
   //
   // Details
   //  If the CSR[TRDY] has 'locked' on a transmit line and that lines
   //  becomes negated, the transmit scanner should resume scanning for
   //  the next empty transmitter.
   //

   reg       csrTRDY;
   reg [2:0] csrTLINE;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             csrTRDY  <= 0;
             csrTLINE <= 0;
          end
        else
          begin
             if (csrCLR | devRESET)
               begin
                  csrTRDY  <= 0;
                  csrTLINE <= 0;
               end
             else
               begin
                  if (csrTRDY)
                    begin
                       if (((tdrWRITE & devLOBYTE))       |
                           ((csrTLINE == 0) & !tcrLIN[0]) |
                           ((csrTLINE == 1) & !tcrLIN[1]) |
                           ((csrTLINE == 2) & !tcrLIN[2]) |
                           ((csrTLINE == 3) & !tcrLIN[3]) |
                           ((csrTLINE == 4) & !tcrLIN[4]) |
                           ((csrTLINE == 5) & !tcrLIN[5]) |
                           ((csrTLINE == 6) & !tcrLIN[6]) |
                           ((csrTLINE == 7) & !tcrLIN[7]))
                         csrTRDY <= 0;
                    end
                  else
                    begin
                       if (((scan == 0) & tcrLIN[0] & uartTXEMPTY[0]) |
                           ((scan == 1) & tcrLIN[1] & uartTXEMPTY[1]) |
                           ((scan == 2) & tcrLIN[2] & uartTXEMPTY[2]) |
                           ((scan == 3) & tcrLIN[3] & uartTXEMPTY[3]) |
                           ((scan == 4) & tcrLIN[4] & uartTXEMPTY[4]) |
                           ((scan == 5) & tcrLIN[5] & uartTXEMPTY[5]) |
                           ((scan == 6) & tcrLIN[6] & uartTXEMPTY[6]) |
                           ((scan == 7) & tcrLIN[7] & uartTXEMPTY[7]))
                         begin
                            csrTRDY  <= 1;
                            csrTLINE <= scan;
                         end
                    end
               end
          end
     end

   //
   // Build CSR
   //

   wire [15:0] regCSR = {csrTRDY,  csrTIE, rbufSA, csrSAE,  1'b0, csrTLINE[2:0],
                         rbufRDONE, csrRIE, csrMSE, csrCLR, csrMAINT, 3'b0};

endmodule