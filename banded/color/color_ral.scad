// Copyright (c) 2026 Armin Frenzel
// License: LGPL-2.1-or-later
//
// list of color names:
//
// RAL Colors
//
// LEGAL DISCLAIMER:
// "RAL", "RAL Classic" and "RAL Effect" are registered trademarks of RAL gGmbH.
// The RAL color extension in BandedScad is an unofficial, community-maintained
// utility for visual approximation in CAD models and is NOT affiliated with,
// endorsed by, or sponsored by RAL gGmbH.
//

include <banded/color_definition.scad>

include <banded/color/color_ral_classic.scad>
include <banded/color/color_ral_design.scad>
include <banded/color/color_ral_effect.scad>


color_ral =
	[ each is_undef(color_ral_classic) ? [] : prepare_color_list( color_ral_classic )
	, each is_undef(color_ral_design)  ? [] : prepare_color_list( color_ral_design  )
	, each is_undef(color_ral_effect)  ? [] : prepare_color_list( color_ral_effect  )
	];

