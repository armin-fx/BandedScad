// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines functions and modules to keep compatibility
// with older versions than 2019.05
// and newer than or equal 2015.03

if (version_num()>=20190500) echo ("\nWARNING: this version of OpenScad don\'t need \'compatibility_v2015.scad\'\n");

// emulate new testing functions
function is_undef  (value) = (undef==value);
function is_bool   (value) = (value==true || value==false);
//function is_num  (value) = (concat(value)!=value && value+0!=undef && value==value);
function is_num    (value) =
	concat(value)!=value &&
	str(value)!=value &&
	len(search("aut[(", str(value)))==0
;
function is_list   (value) = (concat(value)==value);
function is_string (value) = (str(value)==value);
function is_function (value) =
	let(str_value = str(value))
	concat(value)!=value &&
	str_value!=value &&
	str_value[8]=="("
;

// Convert the first character of the given string to a Unicode code point.
function ord (string) =
	!is_string(string)    ? undef :
	!is_string(string[0]) ? undef :
	ord_intern_range(string)
;
function ord_intern_range (string, under=30, upper=128) =
	string[0]>chr(upper) ? ord_intern_range(string, upper, upper*4) :
	string[0]<chr(under) ? ord_intern_range(string, 0    , under)   :
	ord_intern_search(string, under, upper)
;
function ord_intern_search (string, under=0, upper=255) =
	let( middle=floor((under+upper)/2) )
	string[0]==chr(middle) ? middle :
	string[0]< chr(middle) ?
		ord_intern_search(string, under, middle-1) :
		ord_intern_search(string, middle+1, upper)
;
