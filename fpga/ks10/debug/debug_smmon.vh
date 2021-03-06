////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
// These are the test addresses for SMMON
//
// File
//   debug_smmon.vh
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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

begin
   case (PC)
     18'o000000: test = "SUBSM RESET";

     18'o002000: test = "SUBSM START";
     18'o002001: test = "SUBSM REINIT";
     18'o002002: test = "SUBSM SUBINI";
     18'o002003: test = "SUBSM MODCHK";
     18'o002051: test = "SUBSM $PGMIN";
     18'o002107: test = "SUBSM $PGMIN";
     18'o002112: test = "SUBSM $PGMIN";
     18'o002113: test = "SUBSM $PGMIN";
     18'o002114: test = "SUBSM $PGMIN";
     18'o002115: test = "SUBSM $PGMIN";
     18'o002116: test = "SUBSM $PGMIN";
     18'o002117: test = "SUBSM $PGMIN";
     18'o002120: test = "SUBSM $PGMIN";
     18'o002121: test = "SUBSM $PGMIN";
     18'o002122: test = "SUBSM $PGMIN";
     18'o002127: test = "SUBSM $MODCK";
     18'o002151: test = "SUBSM $MAPEX";
     18'o002165: test = "SUBSM $UUOIN";
     18'o002173: test = "SUBSM $UORTN";
     18'o002241: test = "SUBSM $SUBUO";
     18'o002316: test = "SUBSM $UUO37";
     18'o002367: test = "SUBSM $EG4";
     18'o002400: test = "SUBSM $EG177";
     18'o002410: test = "SUBSM $EGX";
     18'o002412: test = "SUBSM $EGBELL";
     18'o002770: test = "SUBSM $CPUTP";

     18'o003031: test = "SUBSM $SMCSH";
     18'o003155: test = "SUBSM $PNTNM";
     18'o003157: test = "SUBSM $PNTNM";
     18'o003160: test = "SUBSM $PNTNM";
     18'o003174: test = "SUBSM $SMSN";
     18'o003224: test = "SUBSM $SNPNT";
     18'o003233: test = "SUBSM $ITRIN";
     18'o003603: test = "SUBSM $MEMMP";
     18'o003632: test = "SUBSM $MPNEW";
     18'o003656: test = "SUBSM $MPNEW";
     18'o003730: test = "SUBSM $MPCNK";
     18'o003771: test = "SUBSM $MPRST";

     18'o004013: test = "SUBSM $MPEXM";
     18'o004025: test = "SUBSM $MPEXM";
     18'o004026: test = "SUBSM $MPEXM";
     18'o004034: test = "SUBSM $MPCXX";
     18'o004037: test = "SUBSM $MPCXX";
     18'o004316: test = "SUBSM $MPADR";
     18'o004332: test = "SUBSM $MPAD2";
     18'o004437: test = "SUBSM $SWTCH";
     18'o004444: test = "SUBSM $SWCH1";
     18'o004454: test = "SUBSM $SWTIN";
     18'o004456: test = "SUBSM $SWIN1";
     18'o004461: test = "SUBSM $SWIN1";
     18'o004477: test = "SUBSM $SW0";
     18'o004713: test = "SUBSM $TYINI";
     18'o004727: test = "SUBSM $CYTYI";
     18'o004740: test = "SUBSM $KYTYI";
     18'o004751: test = "SUBSM $BYTYI";
     18'o004764: test = "SUBSM $COMTI";
     18'o004767: test = "SUBSM $COMTI";

     18'o005003: test = "SUBSM $CYTYO";
     18'o005031: test = "SUBSM $BYTYO";
     18'o005040: test = "SUBSM $COMTO";
     18'o005055: test = "SUBSM $OPTLK";
     18'o005055: test = "SUBSM $OPTLK";
     18'o005062: test = "SUBSM $OPTLK";
     18'o005134: test = "SUBSM $HEAR";
     18'o005136: test = "SUBSM $TIEX2";
     18'o005146: test = "SUBSM $TIEX2";
     18'o005156: test = "SUBSM $TIRDY";
     18'o005444: test = "SUBSM $PNTIN";
     18'o005471: test = "SUBSM $PNTIN";
     18'o005500: test = "SUBSM $PNTIF";
     18'o005504: test = "SUBSM $PNTIT";
     18'o005511: test = "SUBSM $PNTIT";
     18'o005515: test = "SUBSM $PNTI4";
     18'o005541: test = "SUBSM $PNTIA";

     18'o006010: test = "SUBSM $CHRPN";
     18'o006013: test = "SUBSM $CHRPN";
     18'o006014: test = "SUBSM $PNTLN";
     18'o006024: test = "SUBSM $PNTLN";
     18'o006062: test = "SUBSM $TOUT";
     18'o006120: test = "SUBSM $TOUT5";
     18'o006144: test = "SUBSM $TOUT4";
     18'o006145: test = "SUBSM $TOUT4";
     18'o006155: test = "SUBSM ANYOUT";
     18'o006174: test = "SUBSM $TOUTB";
     18'o006200: test = "SUBSM $TOUTB";
     18'o006273: test = "SUBSM $TOUTA";
     18'o006306: test = "SUBSM $TYOUT";
     18'o006317: test = "SUBSM $TYOUT";
     18'o006324: test = "SUBSM $$C";
     18'o006332: test = "SUBSM $$CE2";
     18'o006333: test = "SUBSM $$CE1";
     18'o006334: test = "SUBSM $$CE";
     18'o006464: test = "SUBSM $COMCTL";
     18'o006466: test = "SUBSM $COMCTL";
     18'o006470: test = "SUBSM $COMCTL";
     18'o006476: test = "SUBSM $COMCTL";
     18'o006500: test = "SUBSM $COMCTL";
     18'o006504: test = "SUBSM $COMCTL";
     18'o006506: test = "SUBSM $COMLIN";
     18'o006507: test = "SUBSM $COMLIN";
     18'o006514: test = "SUBSM $COMLIN";
     18'o006516: test = "SUBSM $COMLIN";
     18'o006624: test = "SUBSM COMTIME";
     18'o006631: test = "SUBSM $COMINI";
     18'o006636: test = "SUBSM $COMINI";
     18'o006641: test = "SUBSM $COMINI";
     18'o006642: test = "SUBSM $COMINI";
     18'o006650: test = "SUBSM $COMINI";
     18'o006655: test = "SUBSM $COMINI";
     18'o006656: test = "SUBSM $COMINI";

     18'o020000: test = "SMMON START";
     18'o020001: test = "SMMON RESTRT";
     18'o020002: test = "SMMON TITLE";
     18'o020003: test = "SMMON RERUN";
     18'o020004: test = "SMMON ONETIM";
     18'o020024: test = "SMMON SELECT";
     18'o020046: test = "SMMON START";
     18'o020050: test = "SMMON START";
     18'o020053: test = "SMMON START";
     18'o020057: test = "SMMON START";
     18'o020060: test = "SMMON START";
     18'o020122: test = "SMMON START";
     18'o020124: test = "SMMON START";
     18'o020131: test = "SMMON START";
     18'o020132: test = "SMMON START";
     18'o021571: test = "SMMON SMINT";
     18'o024064: test = "SMMON USRINT";
     18'o020230: test = "SMMON SNAME";
     18'o023736: test = "SMMON AUTOSL";
     18'o021151: test = "SMMON PNTAL";
     18'o021257: test = "SMMON CRLF1";
     18'o020341: test = "SMMON SIXBP";
     18'o021115: test = "SMMON PNTMSG";
     18'o020424: test = "SMMON FLNAME";
     18'o021756: test = "SMMON DIAGLD";
     18'o023771: test = "SMMON DSKLD";
   endcase
end
