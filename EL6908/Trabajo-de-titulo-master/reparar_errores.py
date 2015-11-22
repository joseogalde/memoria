#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  reparar_errores.py
#  
#  Copyright 2013 Carlos <carlgonz@ug.uchile.cl>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#

import re
import argparse
import os

def make_italic_dict(replace_list):
    i_dic = {}
    
    for word in replace_list:
        exp = r'(?<!\{)('+word+r')(?!\})'
        i_dic[word] = re.compile(exp)
        
    return i_dic

def do_italic(infile, outfile, r_dic):
    _infile = os.path.split(infile)
    tmpfile = os.path.join(_infile[0],'~'+_infile[1][0:_infile[1].rfind('.')]+'.tmp')
    
    if outfile == '' or outfile == infile: outfile = tmpfile
    
    fin = open(infile,'r')
    fout = open(outfile,'w')
    
    for line in fin:
        for word in r_dic:
            line = r_dic[word].sub(r'\\textit{'+word+'}', line)
        fout.write(line)
    
    fout.close()
    fin.close()
    
    if outfile == tmpfile:
        os.remove(infile)
        os.rename(outfile, infile)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', help='Input file')
    parser.add_argument('-o','--outfile', default = '', help='Output file, input file will not be modified')
    parser.add_argument('-i','--italic', nargs='+', help='A list of words to convert to italic')
    
    args = parser.parse_args()
    
    italic_dict = make_italic_dict(args.italic)
    do_italic(args.infile, args.outfile, italic_dict)
