// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
//
// load the entire BandedScad-bibliothek
//
// bind: include <banded.scad>
//

/* [bibliothek BandedScad] */

// Version number
// Number format: year 4 digit - month 2 digit - day 2 digit
//
function version_banded() = 20240118;

version_banded = version_banded();

include <banded/constants.scad>
include <banded/math.scad>
include <banded/list.scad>
include <banded/string.scad>
include <banded/function.scad>
include <banded/helper.scad>
include <banded/extend.scad>
include <banded/draft.scad>
include <banded/object.scad>
include <banded/operator.scad>
//
include <banded/debug.scad>
//
include <banded/other.scad>
//
include <banded/benchmark.scad>
