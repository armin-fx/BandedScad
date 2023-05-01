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

// format a string based on the function 'sprintf()' from language 'C'
function print (format="", values) =
	print_find_identifier (format, values)
;
function print_find_identifier (format, values, txt="", pos=0, pv=0) =
	format[pos]==undef ? txt :
	format[pos]=="%"   ?
		format[pos+1]=="%"
		? print_find_identifier (format, values, str(txt,"%"), pos+2, pv)
		: print_read_flags (format, values, txt, pos+1, pv) :
	print_find_identifier (format, values, str(txt,format[pos]), pos+1, pv)
;
function print_read_flags (format, values, txt="", pos=0, pv=0, align=1, sign="", padding=" ", point=false) =
	format[pos]==undef ? txt :
	format[pos]=="-" ? print_read_flags (format, values, txt, pos+1, pv, -1   , sign, padding, point) :
	format[pos]=="+" ? print_read_flags (format, values, txt, pos+1, pv, align, "+" , padding, point) :
	format[pos]==" " ? print_read_flags (format, values, txt, pos+1, pv, align, sign, " "    , point) :
	format[pos]=="0" ? print_read_flags (format, values, txt, pos+1, pv, align, sign, 0      , point) :
	format[pos]=="#" ? print_read_flags (format, values, txt, pos+1, pv, align, sign, padding, true ) :
	let (
		flags = [
			 align
			,sign
			,padding
			,point
		]
	)
	print_read_width (format, values, txt, pos, pv, flags)
;
function print_read_width (format, values, txt="", pos=0, pv=0, flags) =
	format[pos]==undef ? txt :
	is_digit(format[pos]) ?
		let (
			r = str_to_int_pos (format, pos)
		)
		print_read_precision (format, values, txt, r[1] , pv  , flags, r[0])
	:format[pos]=="*" ?
		print_read_precision (format, values, txt, pos+1, pv+1, flags, values[pv])
	:
		print_read_precision (format, values, txt, pos  , pv  , flags)
;
function print_read_precision (format, values, txt="", pos=0, pv=0, flags, width=1) =
	format[pos]==undef ? txt :
	format[pos]=="." ?
		is_digit(format[pos+1]) ?
			let (
				r = str_to_int_pos (format, pos+1)
			)
			print_read_specifier (format, values, txt, r[1] , pv  , flags, width, r[0])
		:format[pos]=="*" ?
			print_read_specifier (format, values, txt, pos+2, pv+1, flags, width, values[pv])
		:
			print_read_specifier (format, values, txt, pos+1, pv  , flags, width)
	:
		print_read_specifier	 (format, values, txt, pos  , pv  , flags, width)
;
function print_read_specifier (format, values, txt="", pos=0, pv=0, flags, width, precision) =
	format[pos]==undef ? txt
	:format[pos]=="i" || format[pos]=="d" || format[pos]=="u" ? // decimal integer
		let (
			v = int_to_str_format (values[pv],
				size   = width,
				sign   = flags[1],
				padding= flags[2],
				align  = flags[0]
				)
		)
		print_find_identifier (format, values, str(txt,v), pos+1, pv+1)
	:
	format[pos]=="e" || format[pos]=="E" ? // scientific notation (mantissa/exponent)
		let (
			v = float_to_str_exp_format (values[pv],
				size     = width,
				digits   = precision==undef ? 6+1 : precision+1,
				sign     = flags[1],
				point    = flags[3],
				padding  = flags[2],
				align    = flags[0],
				compress = false,
				upper    = format[pos]=="E"
				)
		)
		print_find_identifier (format, values, str(txt,v), pos+1, pv+1)
	:
	format[pos]=="f" || format[pos]=="F" ? // decimal floating point
		let (
			v = float_to_str_comma_format (values[pv],
				size     = width,
				precision= precision==undef ? 6 : precision,
				sign     = flags[1],
				point    = flags[3],
				padding  = flags[2],
				align    = flags[0],
				compress = false
				)
		)
		print_find_identifier (format, values, str(txt,v), pos+1, pv+1)
	:
	format[pos]=="g" || format[pos]=="G" ? // decimal floating point, use the shortest representation
		let (
			X = values[pv]<0 ? -values[pv] : values[pv],
			v = (X<=10^6) && (X>=10/10^4)
				?
					float_to_str_comma_format (values[pv],
					size     = width,
					precision= precision==undef ? 6 : precision,
					sign     = flags[1],
					point    = flags[3],
					padding  = flags[2],
					align    = flags[0],
					compress = true
					)
				:
					float_to_str_exp_format (values[pv],
					size     = width,
					digits   = precision==undef ? 6+1 : precision+1,
					sign     = flags[1],
					point    = flags[3],
					padding  = flags[2],
					align    = flags[0],
					compress = true,
					upper    = format[pos]=="G"
					)
		)
		print_find_identifier (format, values, str(txt,v), pos+1, pv+1)
	:
	format[pos]=="c" ? // character
		let (
			v =	is_num   (values[pv]) ? chr(values[pv]) :
				is_string(values[pv]) ? values[pv] :
				""
		)
		print_find_identifier (format, values, str(txt,v), pos+1, pv+1)
	:
	format[pos]=="s" ? // string of characters
		let (
			s = precision==undef ? values[pv] : extract_str (values[pv], begin=0, count=precision),
			v = add_padding_str (s,
				size    = width,
				padding = flags[2],
				align   = flags[0]
				)
		)
		print_find_identifier (format, values, str(txt,v), pos+1, pv+1)
	:
	format[pos]=="x" || format[pos]=="X" ? // unsigned hexadecimal integer
		let (
			v = value_to_hex (values[pv],
				size  = precision==undef ? 1 : precision,
				upper = format[pos]=="X"
				),
			s = add_padding_str (v,
				pre     = flags[3]==false ? "" : format[pos]=="x" ? "0x" : "0X",
				size    = width,
				padding = flags[2],
				align   = flags[0]
				)
		)
		print_find_identifier (format, values, str(txt,s), pos+1, pv+1)
	:
	format[pos]=="o" ? // unsigned octal integer
		let (
			v = value_to_octal (values[pv],
				size  = precision==undef ? 1 : precision
				),
			s = add_padding_str (v,
				pre     = flags[3]==false ? "" : "0",
				size    = width,
				padding = flags[2],
				align   = flags[0]
				)
		)
		print_find_identifier (format, values, str(txt,s), pos+1, pv+1)
	:
		print_find_identifier (format, values, txt, pos+1, pv)
;

