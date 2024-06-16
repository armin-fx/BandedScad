// Copyright (c) 2024 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines the version helper functions and modules


// - Version check:

// test if this version of BandedScad is compatible with the destinated version
function is_compatible (version, current=version_banded, convert=true) =
	is_version_list(version) ?
	// check a list with version numbers
	// returns true if one version in the list fits
	[ for (v=version)
		if (is_compatible (v, current, convert=convert ) )
			0
	] != []
	:
	// check a single version number
	let (
		Version = convert ? convert_version(version) : version
	)
	(Version[0] == current[0]) && (
		 (Version[1] <  current[1]) ||
		((Version[1] == current[1]) && (Version[2] < current[2]) ||
		((Version[2] == current[2]) && (
			   (Version[3]==undef && current[3]==undef)
			|| (Version[3]!=undef && current[3]==undef)
			|| (Version[3]!=undef && current[3]!=undef &&
				compare_prerelease (separate_prerelease(Version[3]), separate_prerelease(current[3]))
				)
			))
		)
	)
;

// test if this version of OpenSCAD is compatible with the destinated version
function is_compatible_openscad (version=20210100, current=version_num()) =
	(version <= current)
;

// Assert if the current version is incompatible with the desired version
module required_version (version, current, convert=true)
{
	if (! is_version_list(version))
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
	else
	{
		Version = convert ? convert_version_list(version) : version;
		//
		if (current==undef)
			assert (is_compatible (Version, version_banded(), convert=false), str(
				"Current version ", version_to_str(version_banded()), " of BandedScad",
				" is incompatible with desired versions ",
				[ for (e=Version) version_to_str(e) ]
				) );
		else
			assert (is_compatible (Version, current, convert=false), str(
				"Current version ", version_to_str(current),
				" is incompatible with desired versions ",
				[ for (e=Version) version_to_str(e) ]
			) );
	}
}


// - Convert version format:

// convert a version number to a printable string
function version_to_str (version, default="") =
	is_list (version) ?
		 version[3]!=undef ?
			  str(version[0],".",version[1],".",version[2],"-",version[3])
		:version[2]!=undef ? is_string(version[2])
			? str(version[0],".",version[1],".0-",version[2])
			: str(version[0],".",version[1],".",version[2])
		:version[1]!=undef ? is_string(version[1])
			? str(version[0],".0.0-",version[1])
			: str(version[0],".",version[1],".0")
		:version[0]!=undef ? str(version[0],".0.0")
		:default
	:default
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
		:txt[res[1]]=="-" ?
			str_to_version_intern_pre  (txt, size, res[1]+1,        [ each version, res[0] ])
		:	str_to_version_intern_pre  (txt, size, i,               version)
	: str_to_version_intern_pre  (txt, size, i, version)
;
function str_to_version_intern_pre (txt, size=0, i=0, version=[]) =
	i==size ? fill_version (version) :
	[ each fill_version (version)
	, list_to_str( [for (i=[i:1:size-1]) txt[i] ] )
	]
;

// create a list with pre-release data from string
function separate_prerelease (txt, begin=0) =
	separate_prerelease_intern (txt, len(txt), begin, begin)
;
function separate_prerelease_intern (txt, size=0, begin=0, i=0, type=0, version=[]) =
	i>=size && begin==i ? version :
	//
	i==size || txt[i]=="." ?
		type==1
		? separate_prerelease_intern (txt, size, i+1, i+1, 0, [ each version, list_to_str( [for(j=[begin:1:i-1]) txt[j]] ) ])
		: separate_prerelease_intern (txt, size, i+1, i+1, 0, [ each version, str_to_uint (txt, begin)    ])
	:is_digit (txt, i)
		? separate_prerelease_intern (txt, size, begin, i+1, 0, version)
		: separate_prerelease_intern (txt, size, begin, i+1, 1, version)
;

// compare pre-release list: a < b
function compare_prerelease (a, b) =
	echo(a,b)
	a==b ? true :
	compare_prerelease_intern (a, b, len(a), len(b))
;
function compare_prerelease_intern (a, b, sa=0, sb=0, i=0) =
	(sa==i && sb>=i) ? true :
	(sa>i  && sb==i) ? false :
	a[i]==b[i] ? compare_prerelease_intern (a, b, sa, sb, i+1) :
	(is_num   (a[i]) && is_string(b[i])) ? true :
	(is_string(a[i]) && is_num   (b[i])) ? false :
	a[i]<=b[i] ? true : false
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
// convert a list with versions
function convert_version_list (list, default=[0,0,0]) =
	[ for (version=list) convert_version (version, default) ]
;

// Fill missing version parts with '0' to get a correct version list
function fill_version (version, default=[0,0,0]) =
	version[2]!=undef ? version :
	version[1]!=undef ? [version[0],version[1],0] :
	version[0]!=undef ? [version[0],0,0] :
	default
;
//
function is_version_list (version) =
	(version[0][0]!=undef) && (!is_string(version))
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

