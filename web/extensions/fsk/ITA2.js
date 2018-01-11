/***************************************************************************
 *   Copyright (C) 2011 by Paul Lutus                                      *
 *   lutusp@arachnoid.com                                                  *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/

/**
 *
 * @author lutusp
 */

    function ITA2() {
       var t = this;

       t.last_code = 0;
       t.valid_codes = [];
       t.code_ltrs = []; t.ltrs_code = [];
       t.code_figs = []; t.figs_code = [];
       t.shift = false;
   
       var NUL = '\00';
       var QUO = '\'';
       var LF = '\n';
       var CR = '\r';
       var BEL = '\07';
       var FGS = LTR = '_';   // documentation only

       // generated by /netbackup/data/python_projects/ccir476/./decode_ccir476.py
       t.ltrs = [
        // x0   x1   x2   x3   x4   x5   x6   x7   x8   x9   xa   xb   xc   xd   xe   xf
          NUL, 'E',  LF, 'A', ' ', 'S', 'I', 'U',  CR, 'D', 'R', 'J', 'N', 'F', 'C', 'K',    // 0x
          'T', 'Z', 'L', 'W', 'H', 'Y', 'P', 'Q', 'O', 'B', 'G', FGS, 'M', 'X', 'V', LTR     // 1x
       ];
       
       t.figs = [
        // x0   x1   x2   x3   x4   x5   x6   x7   x8   x9   xa   xb   xc   xd   xe   xf
          NUL, '3',  LF, '-', ' ', BEL, '8', '7',  CR, '$', '4', QUO, ',', '!', ':', '(',    // 0x
          '5', '"', ')', '2', '#', '6', '0', '1', '9', '?', '&', FGS, '.', '/', ';', LTR     // 1x
       ];

        // tables are small enough we don't bother with a hash map/table
        for (var code = 0; code < 32; code++) {
            //if (t.check_bits(code)) {
                t.valid_codes[code] = true;
                var ltrv = t.ltrs[code];
                if (ltrv != '_') {
                    t.code_ltrs[code] = ltrv;
                    t.ltrs_code[ltrv] = code;
                }
                var figv = t.figs[code];
                if (figv != '_') {
                    t.code_figs[code] = figv;
                    t.figs_code[figv] = code;
                }
            //}
        }
    }

    ITA2.prototype.get_shift = function() {
        return this.shift;
    }

    ITA2.prototype.nbits = function() {
        return 15;
    }

    ITA2.prototype.nbit = function() {
        return 0x4000;
    }

    ITA2.prototype.check_valid = function(code) {
        return this.valid_codes[code];
    }

/*
    ITA2.prototype.char_to_code = function(ch, ex_shift) {
        ch = String.toUpperCase(ch);
        // default: return -ch
        int code = -ch;
        // avoid unnececessary shifts
        if (ex_shift && figs_code.containsKey(ch)) {
            code = figs_code.get(ch);
        } else if (!ex_shift && ltrs_code.containsKey(ch)) {
            code = ltrs_code.get(ch);
        } else {
            if (figs_code.containsKey(ch)) {
                shift = true;
                code = figs_code.get(ch);
            } else if (ltrs_code.containsKey(ch)) {
                shift = false;
                code = ltrs_code.get(ch);
            }
        }
        return code;
    }
*/

    ITA2.prototype.code_to_char = function(code, shift) {
        var t = this;
        var ch = shift? t.code_figs[code] : t.code_ltrs[code];
        if (ch == undefined)
            ch = -code;    // default: return negated code
        //console.log('code=0x'+ code.toString(16) +' sft='+ (shift? 'T':'F') +' char='+ ch +'(0x'+ ch.toString(16) +')');
        return ch;
    }

    ITA2.prototype.code = function() {
        return this.last_code;
    }

    ITA2.prototype.check_bits = function(v) {
        var t = this;
        //console.log('ITA2 check_bits 0x'+ v.toString(16));
        if ((v & 0x0003) != 0x0000) return false;     // 1 start bit = 0
        if ((v & 0x7000) != 0x7000) return false;     // 1.5 stop bits = 1
        v >>= 2;
        t.last_code = 0;
        for (var i = 0; i < 5; i++) {
           var d = v & 0x3;
           if (d != 0x0 && d != 0x3) return false;    // data half-bits not the same
           v >>= 2;
           t.last_code = (t.last_code >> 1) | (d? 0x10 : 0);
        }
        //console.log('ITA2 check_bits OK');
        return true;
    }