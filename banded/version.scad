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
// or:     [ MAJOR, MINOR, PATCH, "pre" ]
//
function version_banded() = [ 2, 12, 4 ];

// Version date
//
// Number format: year 4 digit - month 2 digit - day 2 digit
//
function date_banded() = 20240416;


version_banded = version_banded();
date_banded    = date_banded();


// - Version check:

// test if this version of BandedScad is compatible with the destinated version
function is_compatible (version, current=version_banded) =
	(version[0] == current[0]) && (
		 (version[1] <  current[1]) ||
		((version[1] == current[1]) && (version[2] <= current[2]))
	)
;

// test if this version of OpenSCAD is compatible with the destinated version
function is_compatible_openscad (version=20210100, current=version_num()) =
	(version <= current)
;

// Assert if the current version is incompatible with the desired version
module required_version (version, current)
{	
	if (current==undef)
		assert (is_compatible (version, version_banded()), str(
			"Current version ", version_to_str(version_banded()), " of BandedScad",
			" is incompatible with desired version ", version_to_str(version)
			) );
	else
		assert (is_compatible (version, current), str(
			"Current version ", version_to_str(current),
			" is incompatible with desired version ", version_to_str(version)
		) );
}


// - Convert version format:

// convert a version number to a printable string
function version_to_str (version) =
	is_list (version) ?
		version[3]!=undef
		? str(version[0],".",version[1],".",version[2],".",version[3])
		: str(version[0],".",version[1],".",version[2])
	: ""
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

