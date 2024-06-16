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
function version_banded() = [ 3, 1, 0 ];

// Version date
//
// Number format: year 4 digit - month 2 digit - day 2 digit
//
function date_banded() = 20240616;


version_banded = version_banded();
date_banded    = date_banded();


include <banded/version_helper.scad>
