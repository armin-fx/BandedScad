// Copyright (c) 2023 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Formatieren von Strings
//

use <banded/string_convert.scad>


// add padding letters to a string
function add_padding_str (txt="", pre="", size=1, padding=" ", align=1) =
	let (
		l = len(pre) + len(txt)
	)
	l>=size ?
		pre==""
		? txt
		: str (pre, txt)
	:
	
	let (
		 l_pad   = size - l,
		,l_pad_l = floor( (align+1)/2 * l_pad )
		,l_pad_r = l_pad - l_pad_l
	)
	padding==0
		? str( pre, fill_str(l_pad_l, "0"    )     , txt, fill_str(l_pad_r, " ") )
		: str(      fill_str(l_pad_l, padding), pre, txt, fill_str(l_pad_r, " ") )
;

// convert an integer to a string with formatting the text
function int_to_str_format (x, sign=""
	, size=1, padding=" ", align=1) =
	let (
		,s_num  = int_to_str (x<0 ? -x : x)
		,s_sign = x<0 ? "-" : sign
	)
	add_padding_str (s_num, pre=s_sign, size=size, padding=padding, align=align)
;

// convert a floating point number to a string with formatting the text
function float_to_str_format (x, digits=6, compress=true, sign="", point=false, upper=false
	, size=1, padding=" ", align=1) =
	let (
		 s_sign = x<0 ? "-" : sign
		,s_num  = float_to_str (x<0 ? -x : x, digits=digits, compress=compress, point=point, upper=upper)
	)
	add_padding_str (s_num, pre=s_sign, size=size, padding=padding, align=align)
;

function float_to_str_comma_format (x, digits=16, precision, compress=true, sign="", point=false
	, size=1, padding=" ", align=1) =
	let (
		 s_sign = x<0 ? "-" : sign
		,s_num  = float_to_str_comma (x<0 ? -x : x, digits=digits, precision=precision, compress=compress, point=point)
	)
	add_padding_str (s_num, pre=s_sign, size=size, padding=padding, align=align)
;

function float_to_str_exp_format (x, digits=16, compress=true, sign="", point=false, upper=false
	, size=1, padding=" ", align=1) =
	let (
		 s_sign = x<0 ? "-" : sign
		,s_num  = float_to_str_exp (x<0 ? -x : x, digits=digits, compress=compress, point=point, upper=upper)
	)
	add_padding_str (s_num, pre=s_sign, size=size, padding=padding, align=align)
;
