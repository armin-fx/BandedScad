// Copyright (c) 2023 Armin Frenzel
// License: LGPL-2.1-or-later
//
// This contains the data of fonts
//
// Actually the only way to get on the data of fonts
// is to create or clone owns.
//

// include <banded/fonts/font_libbard.scad>
include <banded/fonts/libbard.scad>


font_list = [
	 font_libbard_sans_regular
	,font_libbard_sans_bold
	,font_libbard_sans_italic
	,font_libbard_sans_bold_italic
	,font_libbard_serif_regular
	,font_libbard_serif_bold
	,font_libbard_serif_italic
	,font_libbard_serif_bold_italic
	,font_libbard_sans_narrow_regular
	,font_libbard_sans_narrow_bold
	,font_libbard_sans_narrow_italic
	,font_libbard_sans_narrow_bold_italic
	,font_libbard_mono_regular
	,font_libbard_mono_bold
	,font_libbard_mono_italic
	,font_libbard_mono_bold_italic
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

function get_font_by_name (txt) =
	let (
		 list = split_str (txt, ":")
		,size = len(list)
		,name_= to_lower_str ( remove_all_letter(list[0], " \t\n\r") )
		 // replace "Liberation" to "Libbard" for compatibility reason
		,name =
			mismatch (name_, "liberation")[0] == 10
			? replace_str (name_, "libbard", begin=0, count=10)
			: name_
		,style=
			size<2 ? undef : // <- no style
			let (
				s = [for (i=[1:1:size-1]) if (sequence_positions (list[i], "style=")!=[])
					to_lower_str(strip_str( split_str(list[i],"=")[1] )) ]
			)
			s!=[] ? s[0] : // <- style as string
			//
			// style as list of style combinations:
			[for (i=[1:1:size-1]) to_lower_str(strip_str(list[i])) ]
		//
		,s = len(font_list)
		,name_list =
			let (l = [for (i=[0:1:s-1]) if (name=="" || name==to_lower_str(remove_all_letter(font_list[i][font_data_name]," \t\n\r"))) i])
			l==[] ?  [for (i=[0:1:s-1]) if (   "libbardsans"==to_lower_str(remove_all_letter(font_list[i][font_data_name]," \t\n\r"))) i]
			: l
		,style_list =
			is_string(style)
			? [for (i=name_list) if (style==to_lower_str(strip_str(font_list[i][font_data_style]))) i]
			: value_list(type=[0], list=
			  reverse(
			  sort( type=[1], list=
			  reverse(
				[for (i=name_list)
					let( s = to_lower_str(font_list[i][font_data_style]) )
					[i, len([for (e=style) if (sequence_positions(s,e)!=[]) 0])] ]
				))))
	)
	style_list==[] && name_list==[] ? font_list[0] :
	style_list==[]                  ? font_list[name_list[0]]
	:                                 font_list[style_list[0]]
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

