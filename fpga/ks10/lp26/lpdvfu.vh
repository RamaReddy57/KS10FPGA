////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Line Printer Vertical Format Unit data.
//
// Details
//   The module provides printer's Vertical Format Unit memory contents for
//   LP05, LP14, and LP26 printers.
//
//   One memory is ROM-line and provides the contents of a DEC standard
//   Optical Vertical Format Unit punched-tape.
//
//   The other memory is RAM-like and is used by the Direct Access Vertical
//   Format Unit simulation.
//
// File
//   lpdvfu.dat
//
// Note
//   The Optical VFU data is formatted as follows:
//
//   Chan   Description         Programming
//   ----   ------------------  ----------------
//    12    Bottom-of-form (MSB)
//    11    User defined        Not programmed
//    10    User defined        Not programmed
//     9    User defined        Not programmed
//     8    Printable
//     7    User defined        Twenty spaces
//     6    User defined        Ten spaces
//     5    Slew
//     4    User defined        Triple space
//     3    User defined        Double space
//     2    Vertical Tab        Thirty spaces
//     1    Top-of-form (LSB)
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2017 Rob Doyle
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

`define VFU_SLEW(data) (data[5])
`define VFU_CHAN(data) (data[4:1])

begin

   //
   // Initial OVFU Data
   //
   //                     111 000 000 000
   //                     210 987 654 321

   lpVFUDAT[0][  0] = 12'b000_011_111_111;    // Line  0
   lpVFUDAT[0][  1] = 12'b000_010_010_000;    // Line  1
   lpVFUDAT[0][  2] = 12'b000_010_010_100;    // Line  2
   lpVFUDAT[0][  3] = 12'b000_010_011_000;    // Line  3
   lpVFUDAT[0][  4] = 12'b000_010_010_100;    // Line  4
   lpVFUDAT[0][  5] = 12'b000_010_010_000;    // Line  5
   lpVFUDAT[0][  6] = 12'b000_010_011_100;    // Line  6
   lpVFUDAT[0][  7] = 12'b000_010_010_000;    // Line  7
   lpVFUDAT[0][  8] = 12'b000_010_010_100;    // Line  8
   lpVFUDAT[0][  9] = 12'b000_010_011_000;    // Line  9
   lpVFUDAT[0][ 10] = 12'b000_010_110_100;    // Line 10
   lpVFUDAT[0][ 11] = 12'b000_010_010_000;    // Line 11
   lpVFUDAT[0][ 12] = 12'b000_010_011_100;    // Line 12
   lpVFUDAT[0][ 13] = 12'b000_010_010_000;    // Line 13
   lpVFUDAT[0][ 14] = 12'b000_010_010_100;    // Line 14
   lpVFUDAT[0][ 15] = 12'b000_010_011_000;    // Line 15
   lpVFUDAT[0][ 16] = 12'b000_010_010_100;    // Line 16
   lpVFUDAT[0][ 17] = 12'b000_010_010_000;    // Line 17
   lpVFUDAT[0][ 18] = 12'b000_010_011_100;    // Line 18
   lpVFUDAT[0][ 19] = 12'b000_010_010_000;    // Line 19
   lpVFUDAT[0][ 20] = 12'b000_011_110_100;    // Line 20
   lpVFUDAT[0][ 21] = 12'b000_010_011_000;    // Line 21
   lpVFUDAT[0][ 22] = 12'b000_010_010_100;    // Line 22
   lpVFUDAT[0][ 23] = 12'b000_010_010_000;    // Line 23
   lpVFUDAT[0][ 24] = 12'b000_010_011_100;    // Line 24
   lpVFUDAT[0][ 25] = 12'b000_010_010_000;    // Line 25
   lpVFUDAT[0][ 26] = 12'b000_010_010_100;    // Line 26
   lpVFUDAT[0][ 27] = 12'b000_010_011_000;    // Line 27
   lpVFUDAT[0][ 28] = 12'b000_010_010_100;    // Line 28
   lpVFUDAT[0][ 29] = 12'b000_010_010_000;    // Line 29
   lpVFUDAT[0][ 30] = 12'b000_010_111_110;    // Line 30
   lpVFUDAT[0][ 31] = 12'b000_010_010_000;    // Line 31
   lpVFUDAT[0][ 32] = 12'b000_010_010_100;    // Line 32
   lpVFUDAT[0][ 33] = 12'b000_010_011_000;    // Line 33
   lpVFUDAT[0][ 34] = 12'b000_010_010_100;    // Line 34
   lpVFUDAT[0][ 35] = 12'b000_010_010_000;    // Line 35
   lpVFUDAT[0][ 36] = 12'b000_010_011_100;    // Line 36
   lpVFUDAT[0][ 37] = 12'b000_010_010_000;    // Line 37
   lpVFUDAT[0][ 38] = 12'b000_010_010_100;    // Line 38
   lpVFUDAT[0][ 39] = 12'b000_010_011_000;    // Line 39
   lpVFUDAT[0][ 40] = 12'b000_011_110_100;    // Line 40
   lpVFUDAT[0][ 41] = 12'b000_010_010_000;    // Line 41
   lpVFUDAT[0][ 42] = 12'b000_010_011_100;    // Line 42
   lpVFUDAT[0][ 43] = 12'b000_010_010_000;    // Line 43
   lpVFUDAT[0][ 44] = 12'b000_010_010_100;    // Line 44
   lpVFUDAT[0][ 45] = 12'b000_010_011_000;    // Line 45
   lpVFUDAT[0][ 46] = 12'b000_010_010_100;    // Line 46
   lpVFUDAT[0][ 47] = 12'b000_010_010_000;    // Line 47
   lpVFUDAT[0][ 48] = 12'b000_010_011_100;    // Line 48
   lpVFUDAT[0][ 49] = 12'b000_010_010_000;    // Line 49
   lpVFUDAT[0][ 50] = 12'b000_010_110_100;    // Line 50
   lpVFUDAT[0][ 51] = 12'b000_010_011_000;    // Line 51
   lpVFUDAT[0][ 52] = 12'b000_010_010_100;    // Line 52
   lpVFUDAT[0][ 53] = 12'b000_010_010_000;    // Line 53
   lpVFUDAT[0][ 54] = 12'b000_010_011_100;    // Line 54
   lpVFUDAT[0][ 55] = 12'b000_010_010_000;    // Line 55
   lpVFUDAT[0][ 56] = 12'b000_010_010_100;    // Line 56
   lpVFUDAT[0][ 57] = 12'b000_010_011_000;    // Line 57
   lpVFUDAT[0][ 58] = 12'b000_010_010_100;    // Line 58
   lpVFUDAT[0][ 59] = 12'b000_010_010_000;    // Line 59
   lpVFUDAT[0][ 60] = 12'b000_000_010_000;    // Line 60
   lpVFUDAT[0][ 61] = 12'b000_000_010_000;    // Line 61
   lpVFUDAT[0][ 62] = 12'b000_000_010_000;    // Line 62
   lpVFUDAT[0][ 63] = 12'b000_000_010_000;    // Line 63
   lpVFUDAT[0][ 64] = 12'b000_000_010_000;    // Line 64
   lpVFUDAT[0][ 65] = 12'b100_000_010_000;    // Line 65
   lpVFUDAT[0][ 66] = 12'b000_000_000_000;
   lpVFUDAT[0][ 67] = 12'b000_000_000_000;
   lpVFUDAT[0][ 68] = 12'b000_000_000_000;
   lpVFUDAT[0][ 69] = 12'b000_000_000_000;
   lpVFUDAT[0][ 70] = 12'b000_000_000_000;
   lpVFUDAT[0][ 71] = 12'b000_000_000_000;
   lpVFUDAT[0][ 72] = 12'b000_000_000_000;
   lpVFUDAT[0][ 73] = 12'b000_000_000_000;
   lpVFUDAT[0][ 74] = 12'b000_000_000_000;
   lpVFUDAT[0][ 75] = 12'b000_000_000_000;
   lpVFUDAT[0][ 76] = 12'b000_000_000_000;
   lpVFUDAT[0][ 77] = 12'b000_000_000_000;
   lpVFUDAT[0][ 78] = 12'b000_000_000_000;
   lpVFUDAT[0][ 79] = 12'b000_000_000_000;
   lpVFUDAT[0][ 80] = 12'b000_000_000_000;
   lpVFUDAT[0][ 81] = 12'b000_000_000_000;
   lpVFUDAT[0][ 82] = 12'b000_000_000_000;
   lpVFUDAT[0][ 83] = 12'b000_000_000_000;
   lpVFUDAT[0][ 84] = 12'b000_000_000_000;
   lpVFUDAT[0][ 85] = 12'b000_000_000_000;
   lpVFUDAT[0][ 86] = 12'b000_000_000_000;
   lpVFUDAT[0][ 87] = 12'b000_000_000_000;
   lpVFUDAT[0][ 88] = 12'b000_000_000_000;
   lpVFUDAT[0][ 89] = 12'b000_000_000_000;
   lpVFUDAT[0][ 90] = 12'b000_000_000_000;
   lpVFUDAT[0][ 91] = 12'b000_000_000_000;
   lpVFUDAT[0][ 92] = 12'b000_000_000_000;
   lpVFUDAT[0][ 93] = 12'b000_000_000_000;
   lpVFUDAT[0][ 94] = 12'b000_000_000_000;
   lpVFUDAT[0][ 95] = 12'b000_000_000_000;
   lpVFUDAT[0][ 96] = 12'b000_000_000_000;
   lpVFUDAT[0][ 97] = 12'b000_000_000_000;
   lpVFUDAT[0][ 98] = 12'b000_000_000_000;
   lpVFUDAT[0][ 99] = 12'b000_000_000_000;
   lpVFUDAT[0][100] = 12'b000_000_000_000;
   lpVFUDAT[0][101] = 12'b000_000_000_000;
   lpVFUDAT[0][102] = 12'b000_000_000_000;
   lpVFUDAT[0][103] = 12'b000_000_000_000;
   lpVFUDAT[0][104] = 12'b000_000_000_000;
   lpVFUDAT[0][105] = 12'b000_000_000_000;
   lpVFUDAT[0][106] = 12'b000_000_000_000;
   lpVFUDAT[0][107] = 12'b000_000_000_000;
   lpVFUDAT[0][108] = 12'b000_000_000_000;
   lpVFUDAT[0][109] = 12'b000_000_000_000;
   lpVFUDAT[0][110] = 12'b000_000_000_000;
   lpVFUDAT[0][111] = 12'b000_000_000_000;
   lpVFUDAT[0][112] = 12'b000_000_000_000;
   lpVFUDAT[0][113] = 12'b000_000_000_000;
   lpVFUDAT[0][114] = 12'b000_000_000_000;
   lpVFUDAT[0][115] = 12'b000_000_000_000;
   lpVFUDAT[0][116] = 12'b000_000_000_000;
   lpVFUDAT[0][117] = 12'b000_000_000_000;
   lpVFUDAT[0][118] = 12'b000_000_000_000;
   lpVFUDAT[0][119] = 12'b000_000_000_000;
   lpVFUDAT[0][120] = 12'b000_000_000_000;
   lpVFUDAT[0][121] = 12'b000_000_000_000;
   lpVFUDAT[0][122] = 12'b000_000_000_000;
   lpVFUDAT[0][123] = 12'b000_000_000_000;
   lpVFUDAT[0][124] = 12'b000_000_000_000;
   lpVFUDAT[0][125] = 12'b000_000_000_000;
   lpVFUDAT[0][126] = 12'b000_000_000_000;
   lpVFUDAT[0][127] = 12'b000_000_000_000;
   lpVFUDAT[0][128] = 12'b000_000_000_000;
   lpVFUDAT[0][129] = 12'b000_000_000_000;
   lpVFUDAT[0][130] = 12'b000_000_000_000;
   lpVFUDAT[0][131] = 12'b000_000_000_000;
   lpVFUDAT[0][132] = 12'b000_000_000_000;
   lpVFUDAT[0][133] = 12'b000_000_000_000;
   lpVFUDAT[0][134] = 12'b000_000_000_000;
   lpVFUDAT[0][135] = 12'b000_000_000_000;
   lpVFUDAT[0][136] = 12'b000_000_000_000;
   lpVFUDAT[0][137] = 12'b000_000_000_000;
   lpVFUDAT[0][138] = 12'b000_000_000_000;
   lpVFUDAT[0][139] = 12'b000_000_000_000;
   lpVFUDAT[0][140] = 12'b000_000_000_000;
   lpVFUDAT[0][141] = 12'b000_000_000_000;
   lpVFUDAT[0][142] = 12'b000_000_000_000;
   lpVFUDAT[0][143] = 12'b000_000_000_000;
   lpVFUDAT[0][144] = 12'b000_000_000_000;
   lpVFUDAT[0][145] = 12'b000_000_000_000;
   lpVFUDAT[0][146] = 12'b000_000_000_000;
   lpVFUDAT[0][147] = 12'b000_000_000_000;
   lpVFUDAT[0][148] = 12'b000_000_000_000;
   lpVFUDAT[0][149] = 12'b000_000_000_000;
   lpVFUDAT[0][150] = 12'b000_000_000_000;
   lpVFUDAT[0][151] = 12'b000_000_000_000;
   lpVFUDAT[0][152] = 12'b000_000_000_000;
   lpVFUDAT[0][153] = 12'b000_000_000_000;
   lpVFUDAT[0][154] = 12'b000_000_000_000;
   lpVFUDAT[0][155] = 12'b000_000_000_000;
   lpVFUDAT[0][156] = 12'b000_000_000_000;
   lpVFUDAT[0][157] = 12'b000_000_000_000;
   lpVFUDAT[0][158] = 12'b000_000_000_000;
   lpVFUDAT[0][159] = 12'b000_000_000_000;
   lpVFUDAT[0][160] = 12'b000_000_000_000;
   lpVFUDAT[0][161] = 12'b000_000_000_000;
   lpVFUDAT[0][162] = 12'b000_000_000_000;
   lpVFUDAT[0][163] = 12'b000_000_000_000;
   lpVFUDAT[0][164] = 12'b000_000_000_000;
   lpVFUDAT[0][165] = 12'b000_000_000_000;
   lpVFUDAT[0][166] = 12'b000_000_000_000;
   lpVFUDAT[0][167] = 12'b000_000_000_000;
   lpVFUDAT[0][168] = 12'b000_000_000_000;
   lpVFUDAT[0][169] = 12'b000_000_000_000;
   lpVFUDAT[0][170] = 12'b000_000_000_000;
   lpVFUDAT[0][171] = 12'b000_000_000_000;
   lpVFUDAT[0][172] = 12'b000_000_000_000;
   lpVFUDAT[0][173] = 12'b000_000_000_000;
   lpVFUDAT[0][174] = 12'b000_000_000_000;
   lpVFUDAT[0][175] = 12'b000_000_000_000;
   lpVFUDAT[0][176] = 12'b000_000_000_000;
   lpVFUDAT[0][177] = 12'b000_000_000_000;
   lpVFUDAT[0][178] = 12'b000_000_000_000;
   lpVFUDAT[0][179] = 12'b000_000_000_000;
   lpVFUDAT[0][180] = 12'b000_000_000_000;
   lpVFUDAT[0][181] = 12'b000_000_000_000;
   lpVFUDAT[0][182] = 12'b000_000_000_000;
   lpVFUDAT[0][183] = 12'b000_000_000_000;
   lpVFUDAT[0][184] = 12'b000_000_000_000;
   lpVFUDAT[0][185] = 12'b000_000_000_000;
   lpVFUDAT[0][186] = 12'b000_000_000_000;
   lpVFUDAT[0][187] = 12'b000_000_000_000;
   lpVFUDAT[0][188] = 12'b000_000_000_000;
   lpVFUDAT[0][189] = 12'b000_000_000_000;
   lpVFUDAT[0][190] = 12'b000_000_000_000;
   lpVFUDAT[0][191] = 12'b000_000_000_000;
   lpVFUDAT[0][192] = 12'b000_000_000_000;
   lpVFUDAT[0][193] = 12'b000_000_000_000;
   lpVFUDAT[0][194] = 12'b000_000_000_000;
   lpVFUDAT[0][195] = 12'b000_000_000_000;
   lpVFUDAT[0][196] = 12'b000_000_000_000;
   lpVFUDAT[0][197] = 12'b000_000_000_000;
   lpVFUDAT[0][198] = 12'b000_000_000_000;
   lpVFUDAT[0][199] = 12'b000_000_000_000;
   lpVFUDAT[0][200] = 12'b000_000_000_000;
   lpVFUDAT[0][201] = 12'b000_000_000_000;
   lpVFUDAT[0][202] = 12'b000_000_000_000;
   lpVFUDAT[0][203] = 12'b000_000_000_000;
   lpVFUDAT[0][204] = 12'b000_000_000_000;
   lpVFUDAT[0][205] = 12'b000_000_000_000;
   lpVFUDAT[0][206] = 12'b000_000_000_000;
   lpVFUDAT[0][207] = 12'b000_000_000_000;
   lpVFUDAT[0][208] = 12'b000_000_000_000;
   lpVFUDAT[0][209] = 12'b000_000_000_000;
   lpVFUDAT[0][210] = 12'b000_000_000_000;
   lpVFUDAT[0][211] = 12'b000_000_000_000;
   lpVFUDAT[0][212] = 12'b000_000_000_000;
   lpVFUDAT[0][213] = 12'b000_000_000_000;
   lpVFUDAT[0][214] = 12'b000_000_000_000;
   lpVFUDAT[0][215] = 12'b000_000_000_000;
   lpVFUDAT[0][216] = 12'b000_000_000_000;
   lpVFUDAT[0][217] = 12'b000_000_000_000;
   lpVFUDAT[0][218] = 12'b000_000_000_000;
   lpVFUDAT[0][219] = 12'b000_000_000_000;
   lpVFUDAT[0][220] = 12'b000_000_000_000;
   lpVFUDAT[0][221] = 12'b000_000_000_000;
   lpVFUDAT[0][222] = 12'b000_000_000_000;
   lpVFUDAT[0][223] = 12'b000_000_000_000;
   lpVFUDAT[0][224] = 12'b000_000_000_000;
   lpVFUDAT[0][225] = 12'b000_000_000_000;
   lpVFUDAT[0][226] = 12'b000_000_000_000;
   lpVFUDAT[0][227] = 12'b000_000_000_000;
   lpVFUDAT[0][228] = 12'b000_000_000_000;
   lpVFUDAT[0][229] = 12'b000_000_000_000;
   lpVFUDAT[0][230] = 12'b000_000_000_000;
   lpVFUDAT[0][231] = 12'b000_000_000_000;
   lpVFUDAT[0][232] = 12'b000_000_000_000;
   lpVFUDAT[0][233] = 12'b000_000_000_000;
   lpVFUDAT[0][234] = 12'b000_000_000_000;
   lpVFUDAT[0][235] = 12'b000_000_000_000;
   lpVFUDAT[0][236] = 12'b000_000_000_000;
   lpVFUDAT[0][237] = 12'b000_000_000_000;
   lpVFUDAT[0][238] = 12'b000_000_000_000;
   lpVFUDAT[0][239] = 12'b000_000_000_000;
   lpVFUDAT[0][240] = 12'b000_000_000_000;
   lpVFUDAT[0][241] = 12'b000_000_000_000;
   lpVFUDAT[0][242] = 12'b000_000_000_000;
   lpVFUDAT[0][243] = 12'b000_000_000_000;
   lpVFUDAT[0][244] = 12'b000_000_000_000;
   lpVFUDAT[0][245] = 12'b000_000_000_000;
   lpVFUDAT[0][246] = 12'b000_000_000_000;
   lpVFUDAT[0][247] = 12'b000_000_000_000;
   lpVFUDAT[0][248] = 12'b000_000_000_000;
   lpVFUDAT[0][249] = 12'b000_000_000_000;
   lpVFUDAT[0][250] = 12'b000_000_000_000;
   lpVFUDAT[0][251] = 12'b000_000_000_000;
   lpVFUDAT[0][252] = 12'b000_000_000_000;
   lpVFUDAT[0][253] = 12'b000_000_000_000;
   lpVFUDAT[0][254] = 12'b000_000_000_000;
   lpVFUDAT[0][255] = 12'b000_000_000_000;

   //
   // Initial DAVFU Data
   //
   //                     111 000 000 000
   //                     210 987 654 321

   lpVFUDAT[1][  0] = 12'b000_000_000_000;
   lpVFUDAT[1][  1] = 12'b000_000_000_000;
   lpVFUDAT[1][  2] = 12'b000_000_000_000;
   lpVFUDAT[1][  3] = 12'b000_000_000_000;
   lpVFUDAT[1][  4] = 12'b000_000_000_000;
   lpVFUDAT[1][  5] = 12'b000_000_000_000;
   lpVFUDAT[1][  6] = 12'b000_000_000_000;
   lpVFUDAT[1][  7] = 12'b000_000_000_000;
   lpVFUDAT[1][  8] = 12'b000_000_000_000;
   lpVFUDAT[1][  9] = 12'b000_000_000_000;
   lpVFUDAT[1][ 10] = 12'b000_000_000_000;
   lpVFUDAT[1][ 11] = 12'b000_000_000_000;
   lpVFUDAT[1][ 12] = 12'b000_000_000_000;
   lpVFUDAT[1][ 13] = 12'b000_000_000_000;
   lpVFUDAT[1][ 14] = 12'b000_000_000_000;
   lpVFUDAT[1][ 15] = 12'b000_000_000_000;
   lpVFUDAT[1][ 16] = 12'b000_000_000_000;
   lpVFUDAT[1][ 17] = 12'b000_000_000_000;
   lpVFUDAT[1][ 18] = 12'b000_000_000_000;
   lpVFUDAT[1][ 19] = 12'b000_000_000_000;
   lpVFUDAT[1][ 20] = 12'b000_000_000_000;
   lpVFUDAT[1][ 21] = 12'b000_000_000_000;
   lpVFUDAT[1][ 22] = 12'b000_000_000_000;
   lpVFUDAT[1][ 23] = 12'b000_000_000_000;
   lpVFUDAT[1][ 24] = 12'b000_000_000_000;
   lpVFUDAT[1][ 25] = 12'b000_000_000_000;
   lpVFUDAT[1][ 26] = 12'b000_000_000_000;
   lpVFUDAT[1][ 27] = 12'b000_000_000_000;
   lpVFUDAT[1][ 28] = 12'b000_000_000_000;
   lpVFUDAT[1][ 29] = 12'b000_000_000_000;
   lpVFUDAT[1][ 30] = 12'b000_000_000_000;
   lpVFUDAT[1][ 31] = 12'b000_000_000_000;
   lpVFUDAT[1][ 32] = 12'b000_000_000_000;
   lpVFUDAT[1][ 33] = 12'b000_000_000_000;
   lpVFUDAT[1][ 34] = 12'b000_000_000_000;
   lpVFUDAT[1][ 35] = 12'b000_000_000_000;
   lpVFUDAT[1][ 36] = 12'b000_000_000_000;
   lpVFUDAT[1][ 37] = 12'b000_000_000_000;
   lpVFUDAT[1][ 38] = 12'b000_000_000_000;
   lpVFUDAT[1][ 39] = 12'b000_000_000_000;
   lpVFUDAT[1][ 40] = 12'b000_000_000_000;
   lpVFUDAT[1][ 41] = 12'b000_000_000_000;
   lpVFUDAT[1][ 42] = 12'b000_000_000_000;
   lpVFUDAT[1][ 43] = 12'b000_000_000_000;
   lpVFUDAT[1][ 44] = 12'b000_000_000_000;
   lpVFUDAT[1][ 45] = 12'b000_000_000_000;
   lpVFUDAT[1][ 46] = 12'b000_000_000_000;
   lpVFUDAT[1][ 47] = 12'b000_000_000_000;
   lpVFUDAT[1][ 48] = 12'b000_000_000_000;
   lpVFUDAT[1][ 49] = 12'b000_000_000_000;
   lpVFUDAT[1][ 50] = 12'b000_000_000_000;
   lpVFUDAT[1][ 51] = 12'b000_000_000_000;
   lpVFUDAT[1][ 52] = 12'b000_000_000_000;
   lpVFUDAT[1][ 53] = 12'b000_000_000_000;
   lpVFUDAT[1][ 54] = 12'b000_000_000_000;
   lpVFUDAT[1][ 55] = 12'b000_000_000_000;
   lpVFUDAT[1][ 56] = 12'b000_000_000_000;
   lpVFUDAT[1][ 57] = 12'b000_000_000_000;
   lpVFUDAT[1][ 58] = 12'b000_000_000_000;
   lpVFUDAT[1][ 59] = 12'b000_000_000_000;
   lpVFUDAT[1][ 60] = 12'b000_000_000_000;
   lpVFUDAT[1][ 61] = 12'b000_000_000_000;
   lpVFUDAT[1][ 62] = 12'b000_000_000_000;
   lpVFUDAT[1][ 63] = 12'b000_000_000_000;
   lpVFUDAT[1][ 64] = 12'b000_000_000_000;
   lpVFUDAT[1][ 65] = 12'b000_000_000_000;
   lpVFUDAT[1][ 66] = 12'b000_000_000_000;
   lpVFUDAT[1][ 67] = 12'b000_000_000_000;
   lpVFUDAT[1][ 68] = 12'b000_000_000_000;
   lpVFUDAT[1][ 69] = 12'b000_000_000_000;
   lpVFUDAT[1][ 70] = 12'b000_000_000_000;
   lpVFUDAT[1][ 71] = 12'b000_000_000_000;
   lpVFUDAT[1][ 72] = 12'b000_000_000_000;
   lpVFUDAT[1][ 73] = 12'b000_000_000_000;
   lpVFUDAT[1][ 74] = 12'b000_000_000_000;
   lpVFUDAT[1][ 75] = 12'b000_000_000_000;
   lpVFUDAT[1][ 76] = 12'b000_000_000_000;
   lpVFUDAT[1][ 77] = 12'b000_000_000_000;
   lpVFUDAT[1][ 78] = 12'b000_000_000_000;
   lpVFUDAT[1][ 79] = 12'b000_000_000_000;
   lpVFUDAT[1][ 80] = 12'b000_000_000_000;
   lpVFUDAT[1][ 81] = 12'b000_000_000_000;
   lpVFUDAT[1][ 82] = 12'b000_000_000_000;
   lpVFUDAT[1][ 83] = 12'b000_000_000_000;
   lpVFUDAT[1][ 84] = 12'b000_000_000_000;
   lpVFUDAT[1][ 85] = 12'b000_000_000_000;
   lpVFUDAT[1][ 86] = 12'b000_000_000_000;
   lpVFUDAT[1][ 87] = 12'b000_000_000_000;
   lpVFUDAT[1][ 88] = 12'b000_000_000_000;
   lpVFUDAT[1][ 89] = 12'b000_000_000_000;
   lpVFUDAT[1][ 90] = 12'b000_000_000_000;
   lpVFUDAT[1][ 91] = 12'b000_000_000_000;
   lpVFUDAT[1][ 92] = 12'b000_000_000_000;
   lpVFUDAT[1][ 93] = 12'b000_000_000_000;
   lpVFUDAT[1][ 94] = 12'b000_000_000_000;
   lpVFUDAT[1][ 95] = 12'b000_000_000_000;
   lpVFUDAT[1][ 96] = 12'b000_000_000_000;
   lpVFUDAT[1][ 97] = 12'b000_000_000_000;
   lpVFUDAT[1][ 98] = 12'b000_000_000_000;
   lpVFUDAT[1][ 99] = 12'b000_000_000_000;
   lpVFUDAT[1][100] = 12'b000_000_000_000;
   lpVFUDAT[1][101] = 12'b000_000_000_000;
   lpVFUDAT[1][102] = 12'b000_000_000_000;
   lpVFUDAT[1][103] = 12'b000_000_000_000;
   lpVFUDAT[1][104] = 12'b000_000_000_000;
   lpVFUDAT[1][105] = 12'b000_000_000_000;
   lpVFUDAT[1][106] = 12'b000_000_000_000;
   lpVFUDAT[1][107] = 12'b000_000_000_000;
   lpVFUDAT[1][108] = 12'b000_000_000_000;
   lpVFUDAT[1][109] = 12'b000_000_000_000;
   lpVFUDAT[1][110] = 12'b000_000_000_000;
   lpVFUDAT[1][111] = 12'b000_000_000_000;
   lpVFUDAT[1][112] = 12'b000_000_000_000;
   lpVFUDAT[1][113] = 12'b000_000_000_000;
   lpVFUDAT[1][114] = 12'b000_000_000_000;
   lpVFUDAT[1][115] = 12'b000_000_000_000;
   lpVFUDAT[1][116] = 12'b000_000_000_000;
   lpVFUDAT[1][117] = 12'b000_000_000_000;
   lpVFUDAT[1][118] = 12'b000_000_000_000;
   lpVFUDAT[1][119] = 12'b000_000_000_000;
   lpVFUDAT[1][120] = 12'b000_000_000_000;
   lpVFUDAT[1][121] = 12'b000_000_000_000;
   lpVFUDAT[1][122] = 12'b000_000_000_000;
   lpVFUDAT[1][123] = 12'b000_000_000_000;
   lpVFUDAT[1][124] = 12'b000_000_000_000;
   lpVFUDAT[1][125] = 12'b000_000_000_000;
   lpVFUDAT[1][126] = 12'b000_000_000_000;
   lpVFUDAT[1][127] = 12'b000_000_000_000;
   lpVFUDAT[1][128] = 12'b000_000_000_000;
   lpVFUDAT[1][129] = 12'b000_000_000_000;
   lpVFUDAT[1][130] = 12'b000_000_000_000;
   lpVFUDAT[1][131] = 12'b000_000_000_000;
   lpVFUDAT[1][132] = 12'b000_000_000_000;
   lpVFUDAT[1][133] = 12'b000_000_000_000;
   lpVFUDAT[1][134] = 12'b000_000_000_000;
   lpVFUDAT[1][135] = 12'b000_000_000_000;
   lpVFUDAT[1][136] = 12'b000_000_000_000;
   lpVFUDAT[1][137] = 12'b000_000_000_000;
   lpVFUDAT[1][138] = 12'b000_000_000_000;
   lpVFUDAT[1][139] = 12'b000_000_000_000;
   lpVFUDAT[1][140] = 12'b000_000_000_000;
   lpVFUDAT[1][141] = 12'b000_000_000_000;
   lpVFUDAT[1][142] = 12'b000_000_000_000;
   lpVFUDAT[1][143] = 12'b000_000_000_000;
   lpVFUDAT[1][144] = 12'b000_000_000_000;
   lpVFUDAT[1][145] = 12'b000_000_000_000;
   lpVFUDAT[1][146] = 12'b000_000_000_000;
   lpVFUDAT[1][147] = 12'b000_000_000_000;
   lpVFUDAT[1][148] = 12'b000_000_000_000;
   lpVFUDAT[1][149] = 12'b000_000_000_000;
   lpVFUDAT[1][150] = 12'b000_000_000_000;
   lpVFUDAT[1][151] = 12'b000_000_000_000;
   lpVFUDAT[1][152] = 12'b000_000_000_000;
   lpVFUDAT[1][153] = 12'b000_000_000_000;
   lpVFUDAT[1][154] = 12'b000_000_000_000;
   lpVFUDAT[1][155] = 12'b000_000_000_000;
   lpVFUDAT[1][156] = 12'b000_000_000_000;
   lpVFUDAT[1][157] = 12'b000_000_000_000;
   lpVFUDAT[1][158] = 12'b000_000_000_000;
   lpVFUDAT[1][159] = 12'b000_000_000_000;
   lpVFUDAT[1][160] = 12'b000_000_000_000;
   lpVFUDAT[1][161] = 12'b000_000_000_000;
   lpVFUDAT[1][162] = 12'b000_000_000_000;
   lpVFUDAT[1][163] = 12'b000_000_000_000;
   lpVFUDAT[1][164] = 12'b000_000_000_000;
   lpVFUDAT[1][165] = 12'b000_000_000_000;
   lpVFUDAT[1][166] = 12'b000_000_000_000;
   lpVFUDAT[1][167] = 12'b000_000_000_000;
   lpVFUDAT[1][168] = 12'b000_000_000_000;
   lpVFUDAT[1][169] = 12'b000_000_000_000;
   lpVFUDAT[1][170] = 12'b000_000_000_000;
   lpVFUDAT[1][171] = 12'b000_000_000_000;
   lpVFUDAT[1][172] = 12'b000_000_000_000;
   lpVFUDAT[1][173] = 12'b000_000_000_000;
   lpVFUDAT[1][174] = 12'b000_000_000_000;
   lpVFUDAT[1][175] = 12'b000_000_000_000;
   lpVFUDAT[1][176] = 12'b000_000_000_000;
   lpVFUDAT[1][177] = 12'b000_000_000_000;
   lpVFUDAT[1][178] = 12'b000_000_000_000;
   lpVFUDAT[1][179] = 12'b000_000_000_000;
   lpVFUDAT[1][180] = 12'b000_000_000_000;
   lpVFUDAT[1][181] = 12'b000_000_000_000;
   lpVFUDAT[1][182] = 12'b000_000_000_000;
   lpVFUDAT[1][183] = 12'b000_000_000_000;
   lpVFUDAT[1][184] = 12'b000_000_000_000;
   lpVFUDAT[1][185] = 12'b000_000_000_000;
   lpVFUDAT[1][186] = 12'b000_000_000_000;
   lpVFUDAT[1][187] = 12'b000_000_000_000;
   lpVFUDAT[1][188] = 12'b000_000_000_000;
   lpVFUDAT[1][189] = 12'b000_000_000_000;
   lpVFUDAT[1][190] = 12'b000_000_000_000;
   lpVFUDAT[1][191] = 12'b000_000_000_000;
   lpVFUDAT[1][192] = 12'b000_000_000_000;
   lpVFUDAT[1][193] = 12'b000_000_000_000;
   lpVFUDAT[1][194] = 12'b000_000_000_000;
   lpVFUDAT[1][195] = 12'b000_000_000_000;
   lpVFUDAT[1][196] = 12'b000_000_000_000;
   lpVFUDAT[1][197] = 12'b000_000_000_000;
   lpVFUDAT[1][198] = 12'b000_000_000_000;
   lpVFUDAT[1][199] = 12'b000_000_000_000;
   lpVFUDAT[1][200] = 12'b000_000_000_000;
   lpVFUDAT[1][201] = 12'b000_000_000_000;
   lpVFUDAT[1][202] = 12'b000_000_000_000;
   lpVFUDAT[1][203] = 12'b000_000_000_000;
   lpVFUDAT[1][204] = 12'b000_000_000_000;
   lpVFUDAT[1][205] = 12'b000_000_000_000;
   lpVFUDAT[1][206] = 12'b000_000_000_000;
   lpVFUDAT[1][207] = 12'b000_000_000_000;
   lpVFUDAT[1][208] = 12'b000_000_000_000;
   lpVFUDAT[1][209] = 12'b000_000_000_000;
   lpVFUDAT[1][210] = 12'b000_000_000_000;
   lpVFUDAT[1][211] = 12'b000_000_000_000;
   lpVFUDAT[1][212] = 12'b000_000_000_000;
   lpVFUDAT[1][213] = 12'b000_000_000_000;
   lpVFUDAT[1][214] = 12'b000_000_000_000;
   lpVFUDAT[1][215] = 12'b000_000_000_000;
   lpVFUDAT[1][216] = 12'b000_000_000_000;
   lpVFUDAT[1][217] = 12'b000_000_000_000;
   lpVFUDAT[1][218] = 12'b000_000_000_000;
   lpVFUDAT[1][219] = 12'b000_000_000_000;
   lpVFUDAT[1][220] = 12'b000_000_000_000;
   lpVFUDAT[1][221] = 12'b000_000_000_000;
   lpVFUDAT[1][222] = 12'b000_000_000_000;
   lpVFUDAT[1][223] = 12'b000_000_000_000;
   lpVFUDAT[1][224] = 12'b000_000_000_000;
   lpVFUDAT[1][225] = 12'b000_000_000_000;
   lpVFUDAT[1][226] = 12'b000_000_000_000;
   lpVFUDAT[1][227] = 12'b000_000_000_000;
   lpVFUDAT[1][228] = 12'b000_000_000_000;
   lpVFUDAT[1][229] = 12'b000_000_000_000;
   lpVFUDAT[1][230] = 12'b000_000_000_000;
   lpVFUDAT[1][231] = 12'b000_000_000_000;
   lpVFUDAT[1][232] = 12'b000_000_000_000;
   lpVFUDAT[1][233] = 12'b000_000_000_000;
   lpVFUDAT[1][234] = 12'b000_000_000_000;
   lpVFUDAT[1][235] = 12'b000_000_000_000;
   lpVFUDAT[1][236] = 12'b000_000_000_000;
   lpVFUDAT[1][237] = 12'b000_000_000_000;
   lpVFUDAT[1][238] = 12'b000_000_000_000;
   lpVFUDAT[1][239] = 12'b000_000_000_000;
   lpVFUDAT[1][240] = 12'b000_000_000_000;
   lpVFUDAT[1][241] = 12'b000_000_000_000;
   lpVFUDAT[1][242] = 12'b000_000_000_000;
   lpVFUDAT[1][243] = 12'b000_000_000_000;
   lpVFUDAT[1][244] = 12'b000_000_000_000;
   lpVFUDAT[1][245] = 12'b000_000_000_000;
   lpVFUDAT[1][246] = 12'b000_000_000_000;
   lpVFUDAT[1][247] = 12'b000_000_000_000;
   lpVFUDAT[1][248] = 12'b000_000_000_000;
   lpVFUDAT[1][249] = 12'b000_000_000_000;
   lpVFUDAT[1][250] = 12'b000_000_000_000;
   lpVFUDAT[1][251] = 12'b000_000_000_000;
   lpVFUDAT[1][252] = 12'b000_000_000_000;
   lpVFUDAT[1][253] = 12'b000_000_000_000;
   lpVFUDAT[1][254] = 12'b000_000_000_000;
   lpVFUDAT[1][255] = 12'b000_000_000_000;
end
