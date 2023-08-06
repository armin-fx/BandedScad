// Copyright (c) 2023 Armin Frenzel
// License: LGPL-2.1-or-later
//
// This contains the data of fonts
//
// Actually the only way to get on the data of fonts
// is to create or clone owns.
//

include <banded/fonts/font_libbard.scad>


font_list = [
	font_libbard
];

function prepare_font (font) =
	[ for (i=[0:1:max (3 , len(font)-1 )])
		 i==font_data_name   ? font[font_data_name]
		:i==font_data_style  ? font[font_data_style]
		:i==font_data_size   ? font[font_data_size]
		:i==font_data_letter ?
			is_sorted (font[font_data_letter], type=[font_letter_name])
			?	font[font_data_letter]
			:	sort (font[font_data_letter], type=[font_letter_name])
		:undef
	]
;

function get_font_letter_object (letter) =
			 is_function(letter) ? letter()
			:is_list    (letter) ? letter
			:undef
;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function bezier_curve_t_2 (p, t=0.5) =
	let (
		 T = 1-t
		,P=p[1], a=p[0], c=p[2]
		,b =
			(P - a*T*T - c*t*t)
			/ (2*t*T)
	)
	bezier_curve ([a,b,c])
;
function bezier_curve_line_2 (p, closed=false) =
	let( s=len(p))
	! closed
	? [ for (i=[0:2:floor(s-3)]) each bezier_curve_t_2 ([p[i],p[i+1],p[ i+2   ]]) ]
	: [ for (i=[0:2:floor(s-2)]) each bezier_curve_t_2 ([p[i],p[i+1],p[(i+2)%s]]) ]
;

