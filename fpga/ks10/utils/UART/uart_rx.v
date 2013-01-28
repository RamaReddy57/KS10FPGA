////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// brief
//  Generic UART Receiver
//
// Details
//   The UART Receiver is hard configured for:
//   - 8 data bits
//   - no parity
//   - 1 stop bit
//
// Note
//   This UART primitive receiver is kept simple intentionally and
//   is therefore unbuffered.  If you require a double buffered UART,
//   then you will need to layer a set of buffers on top of this
//   device.
//
// File
//   uart_rx.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2010, 2011, 2012 Rob Doyle
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

module UART_RX(clk, rst, clkBR, rxd, intr, data);

   input        clk;            // Clock
   input        rst;            // Reset
   input        clkBR;          // Clock Enable from BRG
   input        rxd;            // Receiver Serial Data
   output       intr;           // Data ready
   output [7:0] data;           // Received Data

   //
   // State machine states
   //

   parameter stateIDLE  =  0;   // Idle
   parameter stateSTART =  1;   // Working on Start Bit
   parameter stateBIT0  =  2;   // Working on Bit 7
   parameter stateBIT1  =  3;   // Working on Bit 6
   parameter stateBIT2  =  4;   // Working on Bit 5
   parameter stateBIT3  =  5;   // Working on Bit 4
   parameter stateBIT4  =  6;   // Working on Bit 3
   parameter stateBIT5  =  7;   // Working on Bit 2
   parameter stateBIT6  =  8;   // Working on Bit 1
   parameter stateBIT7  =  9;   // Working on Bit 0
   parameter stateSTOP  = 10;   // Working on Stop Bit
   parameter stateDONE  = 11;   // Generate Interrupt

   //
   // Synchronize the Received Data to this clock domain.
   //

   reg temp;
   reg rxdd;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             temp <= 0;
             rxdd <= 0;
          end
        else
          begin
             temp <= rxd;
             rxdd <= temp;
          end
     end

   //
   // UART Receiver
   //
   // Details
   //   The clkBR is 16 clocks per bit.  The UART receives LSB first.
   //
   //   The state machine is initialized to the idle state where it
   //   looks for a start bit.  When it find the 'edge' of the start
   //   bit starts the state machine which does the following:
   //
   //   -# Continuously sample the start bit for half a bit period.
   //      If the start bit is narrower than half a bit then, go back
   //      to the idle state and look for a real start bit.   Othewise,
   //   -# Delay one bit time from the middle of the Start bit and
   //      sample bit D7 (LSB), then
   //   -# Delay one bit time from the middle of D7 and sample bit D6, then
   //   -# Delay one bit time from the middle of D6 and sample bit D5, then
   //   -# Delay one bit time from the middle of D5 and sample bit D4, then
   //   -# Delay one bit time from the middle of D4 and sample bit D3, then
   //   -# Delay one bit time from the middle of D3 and sample bit D2, then
   //   -# Delay one bit time from the middle of D2 and sample bit D1, then
   //   -# Delay one bit time from the middle of D1 and sample bit D0, then
   //   -# Delay one bit time from the middle of D0 and sample Stop
   //      Bit, then
   //   -# Generate INTR pulse for one clock cycle, then
   //   -# go back to idle state and wait for a start bit.
   //

   reg [3:0] state;
   reg [7:0] rxREG;
   reg [3:0] brdiv;

   always @(posedge clk or posedge rst)
     begin

        if (rst)

          begin
             state <= stateIDLE;
             rxREG <= 0;
             brdiv <= 0;
          end

        else

          case (state)

            //
            // Reciever is Idle
            //

            stateIDLE:
              if (clkBR)
                if (rxdd == 0)
                  begin
                     state <= stateSTART;
                     brdiv <= 8;
                  end

            //
            // Receive Start Bit
            //

            stateSTART:
              if (clkBR)
                if (rxdd == 0)
                  if (brdiv == 0)
                    begin
                       brdiv <= 15;
                       state <= stateBIT0;
                    end
                  else
                    brdiv <= brdiv - 1'b1;
                else
                  state <= stateIDLE;

            //
            // Receive Bit 0 (LSB)
            //

            stateBIT0:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     rxREG <= rxdd & rxREG[7:1];
                     state <= stateBIT1;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Receive Bit 1
            //

            stateBIT1:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     rxREG <= rxdd & rxREG[7:1];
                     state <= stateBIT2;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Receive Bit 2
            //

            stateBIT2:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     rxREG <= rxdd & rxREG[7:1];
                     state <= stateBIT3;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Receive Bit 3
            //

            stateBIT3:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     rxREG <= rxdd & rxREG[7:1];
                     state <= stateBIT4;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Receive Bit 4
            //

            stateBIT4:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     rxREG <= rxdd & rxREG[7:1];
                     state <= stateBIT5;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Receive Bit 5
            //

            stateBIT5:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     rxREG <= rxdd & rxREG[7:1];
                     state <= stateBIT6;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Receive Bit 6
            //

            stateBIT6:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     rxREG <= rxdd & rxREG[7:1];
                     state <= stateBIT7;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Receive Bit 7 (MSB)
            //

            stateBIT7:
              if (clkBR)
                if (brdiv == 0)
                  begin
                     brdiv <= 15;
                     rxREG <= rxdd & rxREG[7:1];
                     state <= stateSTOP;
                  end
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Receive Stop Bit
            //

            stateSTOP:
              if (clkBR)
                if (brdiv == 0)
                  state <= stateDONE;
                else
                  brdiv <= brdiv - 1'b1;

            //
            // Generate Interrupt
            //

            stateDONE:
              state <= stateIDLE;

            //
            // Everything else
            //

            default:
              state <= stateIDLE;

          endcase
     end

   assign intr = (state == stateDONE);
   assign data = rxREG;

endmodule