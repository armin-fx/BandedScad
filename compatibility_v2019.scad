// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines functions and modules to keep compatibility
// with older versions than 2021.01
// and newer than or equal 2019.05

if (version_num()>=20210100)
	echo ("\nWARNING: This version of OpenSCAD don\'t need \'compatibility_v2019.scad\'\n");

// emulate new testing functions
function is_function (value) =
	version_num()<=20190500 ? false :
	let(str_value = str(value))
	concat(value)!=value &&
	str_value!=value &&
	str_value[8]=="("
;
