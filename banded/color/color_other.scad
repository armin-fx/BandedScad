// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// list of names of color
// other color names
//

include <banded/color_definition.scad>


color_banded = [ prepare_color_name( [
	["BandedScad colors"
	,"banded"
	,["en", "de"]
	],[
	// metal
	[[196,196,204], "aluminium", "aluminium"],
	[[255,220,100], "brass"    , "messing"],
	[[224,199,127], "oldbrass" , "altmessing"],
	[[230,140, 51], "copper"   , "kupfer"],
	[[ 92, 84, 84], "iron"     , "eisen"],
	[[115,110,127], "stainless", "edelstahl"],
	[[166,171,184], "steel"    , "stahl"],
	[[199,196,185], "chrome"   , "chrom"],
	[[186,196,200], "zinc"     , "zink"],
	// wood
	[[230,204,153], "birch", "birke"],
	[[166,127,102], "oak"  , "eiche"],
	[[217,179,115], "pine" , "kiefer"]
] ]) ];

