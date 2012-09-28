////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Microcontroller Control ROM 
//!
//! \details
//!
//! \todo
//!
//! \file
//!      crom.v
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

`include "crom.vh"

module CROM(clk, clken, addr, crom);

   parameter cromWidth = `CROM_WIDTH;
   
   input  clk;                  // Clock
   input  clken;                // Clock Enable
   input  [0:11] addr;          // Address
   output [0:cromWidth-1] crom; // Output Data 

   reg    [0:cromWidth-1] crom;
   reg    [0:cromWidth-1] ROM[0:2047];
   
   initial
     $readmemb(`CROM_DATA, ROM, 0, 2047);

   //
   // CROM
   //   Note ROM MSB is ignored.
   //
   
   always @(posedge clk)
     begin
        if (clken)
          begin
             crom <= ROM[addr[1:11]];
          end 
     end

endmodule
