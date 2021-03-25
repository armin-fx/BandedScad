// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines functions and modules which are new in OpenSCAD version 2019.05
// to keep compatibility with OpenSCAD version 2015.03

if (version_num()>=20210100)
	echo ("\nWARNING: This version of OpenSCAD don\'t need \'compatibility_v2015.scad\'\n");
if (version_num()>=20190500 && version_num()<20210100)
	echo ("\nWARNING: This version of OpenSCAD don\'t need \'compatibility_v2015.scad\'. Use \'compatibility_v2019.scad\' instead.\n");

version_num__=version_num();

// emulate new testing functions
function is_undef  (value) = (value==undef);
function is_bool   (value) = (value==true || value==false);
function is_num    (value) =
	value==undef ? false :
	(version_num__<=20190500) ?
	(concat(value)!=value && value+0!=undef && value==value)
	:
	let(v = str(value)[0])
	v=="-" ||
	v=="0" ||
	v=="1" ||
	v=="2" ||
	v=="3" ||
	v=="4" ||
	v=="5" ||
	v=="6" ||
	v=="7" ||
	v=="8" ||
	v=="9" ||
	value==1e200*1e200
;
function is_list   (value) = (concat(value)==value);
function is_string (value) = (str(value)==value);
function is_function (value) =
	version_num__<=20190500 ? false :
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
