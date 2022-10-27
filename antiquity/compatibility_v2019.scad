// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines functions and modules which are new in OpenSCAD version 2021.01
// to keep compatibility with OpenSCAD version 2019.05

if (version_num()>=20210100)
	echo ("\nWARNING: This version of OpenSCAD don\'t need \'compatibility_v2019.scad\'\n");

version_num__=version_num();

// emulate new testing functions
function is_function (value) =
	version_num__<=20190500 ? false :
	let(str_value = str(value))
	concat(value)!=value &&
	str_value!=value &&
	str_value[8]=="("
;
