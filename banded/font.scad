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

