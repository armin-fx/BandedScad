// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Umwandeln von Strings
//

// convert all letter in string 'txt' to a lower case version
function to_lower_case (txt) =
	txt==undef || len(txt)==0 ? txt :
	to_lower_case_intern (txt)
;
function to_lower_case_intern (txt, i=0, new_txt="") =
	i==len(txt) ? new_txt :
	let(
		v = ord(txt[i]),
		l = v>=65 && v<=90  ? chr(v+32) : txt[i]
	)
	to_lower_case_intern (txt, i+1, str(new_txt,l) )
;

// convert all letter in string 'txt' to a upper case version
function to_upper_case (txt) =
	txt==undef || len(txt)==0 ? txt :
	to_upper_case_intern (txt)
;
function to_upper_case_intern (txt, i=0, new_txt="") =
	i==len(txt) ? new_txt :
	let(
		v = ord(txt[i]),
		l = v>=97 && v<=122  ? chr(v-32) : txt[i]
	)
	to_upper_case_intern (txt, i+1, str(new_txt,l) )
;

// convert a numeric integer value to a hexadecimal string
function value_to_hex (value, size=1) =
	value<0  ? undef :
	value_to_hex_intern (value, size)
;
function value_to_hex_intern (value, size=0, string="") =
	value==0 && size<=0 ? string :
	let(
		hex_value  = value%16,
		remainder  = floor( value/16 ),
		hex_letter = hex_value<10 ? chr(48+hex_value) : chr(65-10+hex_value)
	)
	remainder==0 && size<=0 ?
		str(hex_letter, string)
	:	value_to_hex_intern (remainder, size-1, str(hex_letter,string))
;

// convert a hexadecimal string to a numeric value
function hex_to_value (txt, pos=0, size=undef, error=undef) =
	let(
		last =
			size==undef || size<0 ?
				len(txt)   - 1
			:	pos + size - 1
	)
	last>=len(txt) ? error :
	hex_to_value_intern (txt, pos, last, error)
;
function hex_to_value_intern (txt, pos, last, error, value=0) =
	pos>last ? value :
	let( l = hex_letter_to_value (txt, pos) )
	l==undef ? error :
	hex_to_value_intern (txt, pos+1, last, error, value*16 + l)
;

// convert one letter of a hexadecimal string into a numeric value (0 ... 15)
function hex_letter_to_value (txt, pos=0, error=undef) =
	let( t=txt[pos] )
	t<="9" ?
		t<="5" ?
			t<="1" ?
					t=="0" ?  0 :
					t=="1" ?  1 :
					error
			:
				t<="3" ?
					t=="2" ?  2 :
					/*="3"*/  3
				:
					t=="4" ?  4 :
					/*="5"*/  5
		:
				t<="7" ?
					t=="6" ?  6 :
					/*="7"*/  7
				:
					t=="8" ?  8 :
					/*="9"*/  9
	:t<="F" ?
		t<="D" ?
			t<="B" ?
					t=="A" ? 10 :
					t=="B" ? 11 :
					error
			:
					t=="C" ? 12 :
					/*="D"*/ 13
		:
					t=="E" ? 14 :
					/*="F"*/ 15
	:t<="f" ?
		t<="d" ?
			t<="b" ?
					t=="a" ? 10 :
					t=="b" ? 11 :
					error
			:
					t=="c" ? 12 :
					/*="d"*/ 13
		:
					t=="e" ? 14 :
					/*="f"*/ 15
	:error
;

// put every once letter from a string 'txt' into a list
function str_to_list (txt) = [ for (e=txt) e ]
;

// concat every entry in a list to a string
function list_to_str (list) =
	let( size = (list==undef) ? 0 : len(list) )
	size==0 ? "" :
	size==1 ? str( list[0] ) :
	list_to_str_intern (list, size)
;
function list_to_str_intern (list, index=0) =
	index>=16 ?
		str( list_to_str_intern(list, index-16),
			list[index-16], list[index-15], list[index-14], list[index-13],
			list[index-12], list[index-11], list[index-10], list[index-9],
			list[index-8], list[index-7], list[index-6], list[index-5],
			list[index-4], list[index-3], list[index-2], list[index-1] )
	:index>=8 ?
		str( list_to_str_intern(list, index-8),
			list[index-8], list[index-7], list[index-6], list[index-5],
			list[index-4], list[index-3], list[index-2], list[index-1] )
	:index>=4 ?
		str( list_to_str_intern(list, index-4), list[index-4], list[index-3], list[index-2], list[index-1] )
	:index==3 ?
		str( list[0], list[1], list[2] )
	:index==2 ?
		str( list[0], list[1] )
	:index==1 ?
		list[0]
	:""
;
