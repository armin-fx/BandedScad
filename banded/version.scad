// Copyright (c) 2024 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines the version of this bibliothek


// - Current version:

// Version number
//
// see: https://semver.org/
//
// Given a version number MAJOR.MINOR.PATCH, increment the:
// - MAJOR version when you make incompatible API changes
// - MINOR version when you add functionality in a backward compatible manner
// - PATCH version when you make backward compatible bug fixes
//
// format: [ MAJOR, MINOR, PATCH ]
// or:     [ MAJOR, MINOR, PATCH, "pre-release" ]
//
function version_banded() = [ 3, 1, 0, "alpha" ];

// Version date
//
// Number format: year 4 digit - month 2 digit - day 2 digit
//
function date_banded() = 20240616;


version_banded = version_banded();
date_banded    = date_banded();


// - Version check:

// test if this version of BandedScad is compatible with the destinated version
function is_compatible (version, current=version_banded, convert=true) =
	
	let (
		Version = convert ? convert_version(version) : version
	)
	(Version[0] == current[0]) && (
		 (Version[1] <  current[1]) ||
		((Version[1] == current[1]) && (Version[2] <= current[2]))
	)
;

// test if this version of OpenSCAD is compatible with the destinated version
function is_compatible_openscad (version=20210100, current=version_num()) =
	(version <= current)
;

// Assert if the current version is incompatible with the desired version
module required_version (version, current, convert=true)
{
	Version = convert ? convert_version(version) : version;
	//
	if (current==undef)
		assert (is_compatible (Version, version_banded(), convert=false), str(
			"Current version ", version_to_str(version_banded()), " of BandedScad",
			" is incompatible with desired version ", version_to_str(Version)
			) );
	else
		assert (is_compatible (Version, current, convert=false), str(
			"Current version ", version_to_str(current),
			" is incompatible with desired version ", version_to_str(Version)
		) );
}


// - Convert version format:

// convert a version number to a printable string
function version_to_str (version, default="") =
	is_list (version) ?
		version[3]!=undef ? str(version[0],".",version[1],".",version[2],".",version[3]) :
		version[2]!=undef ? str(version[0],".",version[1],".",version[2]) :
		version[1]!=undef ? str(version[0],".",version[1],".0") :
		version[0]!=undef ? str(version[0],".0.0") :
		default
	: default
;

// convert a version number as string to a version list
use <banded/string_convert.scad>
use <banded/string_character.scad>
function str_to_version (txt) =
	str_to_version_intern_first (txt, len(txt))
;
// find first number
function str_to_version_intern_first (txt, size=0, i=0) =
	i==size ? [0,0,0] :
	is_digit (txt, i)
		? str_to_version_intern_loop  (txt, size, i)
		: str_to_version_intern_first (txt, size, i+1)
;
function str_to_version_intern_loop (txt, size=0, i=0, pos=0, version=[]) =
	i==size ? fill_version (version) :
	pos<3 ?
		let( res = str_to_uint_pos (txt, i) )
		res[1]>=size ?
			str_to_version_intern_pre  (txt, size, res[1],          [ each version, res[0] ])
		:txt[res[1]]=="." ?
			str_to_version_intern_loop (txt, size, res[1]+1, pos+1, [ each version, res[0] ])
		:	str_to_version_intern_pre  (txt, size, i,               version)
	: str_to_version_intern_pre  (txt, size, i, version)
;
function str_to_version_intern_pre (txt, size=0, i=0, version=[]) =
	i==size ? fill_version (version) :
	[ each fill_version (version)
	, list_to_str( [for (i=[i:1:size-1]) txt[i] ] )
	]
;

// convert version argument to a version list
// Arguments:
// - as list:
//   - only major version:               [3]           --> [3.0.0]
//   - major and minor version:          [3.1]         --> [3.1.0]
//   - major, minor, patch = default:    [2.1.3]       --> [2.1.3]
//   - major, minor, patch, pre-release: [2.1.3."pre"] --> [2.1.3."pre"]
// - as string:
function convert_version (version, default=[0,0,0]) =
	version==undef ? default :
	is_list(version) ?
		fill_version (version, default)
	:is_string(version) ?
		str_to_version (version)
	:default
;

// Fill missing version parts with '0' to get a correct version list
function fill_version (version, default=[0,0,0]) =
	version[2]!=undef ? version :
	version[1]!=undef ? [version[0],version[1],0] :
	version[0]!=undef ? [version[0],0,0] :
	default
;


// - Deprecated functionality:

// Yield a 'deprecated' message in console
function deprecated (old, alternative, message) =
	assert (old!=undef, "Please set the deprecated functionality as string.")
	let (
		s = str(
			"\nDEPRECATED: ", old, " will be removed in future releases.",
			alternative==undef ? "" : " Use ", alternative," instead.",
			message    ==undef ? "" : str("\n", message)
			)
	)
	echo (
		version_num()>=20210100
		? s
		: str (
			"<span style=\"background-color:yellow\">",
			s,
			"</span>"
		)
	)
;
//
module deprecated (old, alternative, message)
{  x = deprecated (old, alternative, message);
}

