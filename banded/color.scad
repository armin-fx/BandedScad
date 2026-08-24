// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//

use <banded/string.scad>
use <banded/list_edit_data.scad>
use <banded/list_edit_test.scad>
//
include <banded/color_definition.scad>

include <banded/color/color_svg.scad>
include <banded/color/color_other.scad>
include <banded/color/color_ral.scad>


color_list =
	[ each is_undef(color_svg   ) ? [] : prepare_color_list( color_svg    )
	, each is_undef(color_banded) ? [] : prepare_color_list( color_banded )
	, each is_undef(color_ral   ) ? [] : prepare_color_list( color_ral    )
	];

// get color as rgb or rgba list
function get_color (c, alpha, default=undef, colors) =
	is_string(c) ?
		c[0]=="#" ?
			color_hex_to_list (c, alpha)
		:	color_name        (c, alpha, colors)
	:is_num(c[2]) ?
		alpha==undef ? c : [c[0],c[1],c[2],alpha]
	:default
;
// module to use extra color names
module color_extend (c, alpha, default=undef, colors)
{
	color (get_color (c, alpha, default, colors) )
	children();
}

// get a color between 'c' and 'c2'
// with t = 0...1  ==> c...c2
function get_color_between (c, c2, t=0.5, alpha, colors) =
	  (1-t) * get_color (c , alpha, colors=colors)
	+ (t  ) * get_color (c2, alpha, colors=colors)
;
module color_between (c, c2, t=0.5, alpha, colors)
{
	color (get_color_between (c, c2, t, alpha, colors) )
	children();
}


// transform color from hsv model to rgb model
//
// hsv - as list [h, s, v] or [h, s, v, alpha]
//   h = hue:               0...360°
//   s = saturation:        0...1
//   v = value, brightness: 0...1
//   alpha = transparent to opaque: 0...1, default = 1
// return list [r, g, b, alpha]
//   r = red:   0...1
//   g = green: 0...1
//   b = blue:  0...1
function color_hsv_to_rgb (hsv, alpha) =
	hsv[0]==undef ? [0,0,0] :
	let(
		 h=hsv[0]
		,s=hsv[1]
		,v=hsv[2]
		,a=
			alpha !=undef ? alpha :
			hsv[3]!=undef ? hsv[3] :
			1
		//
		,hr = ((h/60) %6+6)%6
		,f  = hr % 1
		,p = v * (1 - s)
		,q = v * (1 - s*f)
		,t = v * (1 - s*(1-f))
		,switch = floor(hr)
	)
	s==0  ? [v,v,v, a] :
	switch==0 ? [v,t,p, a] :
	switch==1 ? [q,v,p, a] :
	switch==2 ? [p,v,t, a] :
	switch==3 ? [p,q,v, a] :
	switch==4 ? [t,p,v, a] :
	switch==5 ? [v,p,q, a] :
	undef
;

// transform color from rgb model to hsv model
//
// rgb - as list [r, g, b] or [r, g, b, alpha]
//   r = red:   0...1
//   g = green: 0...1
//   b = blue:  0...1
//   alpha = transparent to opaque: 0...1, default = 1
// return list [h, s, v, alpha]
//   h = hue:               0...360°
//   s = saturation:        0...1
//   v = value, brightness: 0...1
function color_rgb_to_hsv (rgb, alpha) =
	rgb[2]==undef ? [0,0,0] :
	let(
		 r=rgb[0]
		,g=rgb[1]
		,b=rgb[2]
		,a=
			alpha !=undef ? alpha :
			rgb[3]!=undef ? rgb[3] :
			1
		//
		,M = max(r,g,b)
		,m = min(r,g,b)	
		,h_ =
			M==m ? 0 :
			M==r ? 60 * (0 + (g-b)/(M-m)) :
			M==g ? 60 * (2 + (b-r)/(M-m)) :
			M==b ? 60 * (4 + (r-g)/(M-m)) :
			0
		,h = (h_%360+360)%360
		,s = M==0 ? 0 : (M-m)/M
		,v = M
	)
	[h,s,v, a]
;

// return a color as rgb value as list from the color name
function color_name (name, alpha, colors) =
	name==undef || len(name)<1 ? undef :
	let(
		 a = alpha!=undef ? alpha : 1
		,l = color_name_split (name)
		,Colors = colors==undef ? color_list : colors
		,p = color_name_find (Colors, l, len(Colors))
	)
	let(
		c = p==undef ? undef
			:Colors [p[0]] [color_data_version] == 0 ?
				(Colors [p[0]] [color_data_list] [p[1]] [p[2]] [color_entry_rgb]) / 255
			:Colors [p[0]] [color_data_version] == 1 ?
				(Colors [p[0]] [color_data_list] [  0 ] [p[3]] [color_entry_rgb]) / 255
			:undef
	)
	c==undef ? undef :
	a==1 ? c
	     : [c[0],c[1],c[2], a]
;
// Rückgabe des Treffers:
// [ Position des Farbdatensatzes
// , Position der Farbnamenliste
// , Position der Farbe in der Farbnamenliste
// , Position der Farbe in der RGB Farbliste
// ]
function color_name_find (list, namesplit, s=0, i=0) =
	i>=s ? undef :
	let (
		,info = list[i][color_data_info]
		,lang = info[color_info_language]
		,fn   = info[color_info_function]
		,res =
			// Don't search for colors if a shortname filter is set
			// and don't fits with any shortname of the color list
			// If a color list has no shortname, then this will never used in this case.
			(   namesplit[0]!=""
			 && (info[color_info_shortname]==[] || equal_none( namesplit[0], info[color_info_shortname]) )
			) ? undef :
			//
			// The search method for data version 1 an 2 is the same.
			 list[i][color_data_version]==0 ?
				color_name_find_entry (list[i][color_data_list], namesplit, lang, fn, len(list[i][color_data_list]))
			:list[i][color_data_version]==1 ?
				color_name_find_entry (list[i][color_data_list], namesplit, lang, fn, len(list[i][color_data_list]), 1)
			:undef
	)
	res==undef ? color_name_find (list, namesplit, s, i+1)
	: list[i][color_data_version]==0 ? [ i, res[0], res[1], res[1] ]
	: list[i][color_data_version]==1 ? [ i, res[0], res[1], res[0]==0 ? res[1] : list[i][color_data_list][res[0]][res[1]][color_entry_index] ]
	: undef
;
function color_name_find_entry (list, namesplit, lang, fn, s=0, j=0, l=0) =
	j>=s ?
		// Special handling no data list but language and filter function is active
		(lang[l]==undef || fn==undef)                              ? undef :
		(namesplit[1]!="" && lang[l]!="" && lang[l]!=namesplit[1]) ? undef :
		let ( res = fn (namesplit[2], lang[l]) )
		is_list(res) ? res :
		color_name_find_entry (list, namesplit, lang, fn, s, j+1, l+1)
	:
	let (
		res =
			(namesplit[1]!="" && lang[l]!="" && lang[l]!=namesplit[1]) ? -2
			:
			let (
				name = fn==undef ? namesplit[2] : fn (namesplit[2], lang[l])
			)
			name==undef ? -3
			:
			is_string(name) ?
			binary_search (list[j], name, [color_entry_name])
			:
			name
	)
	is_list(res) ? res :
	res<0
		? color_name_find_entry (list, namesplit, lang, fn, s, j+1, l+1)
		: [j, res]
;
//
// Split the name in parts
// returns:
//   [ color list short name, color language, color name ]
//
// Format of name:
//   "color_name"
//   "short_name:color_name"
//   "short_name:language:color_name"
//   ":language:color_name"
//
// Leading and trailing spaces are removed.
// Multiple consecutive spaces are replaced by a single space.
// Undefined filter will set as an empty string.
// The color name will converted to lowercase letters.
function color_name_split (name) =
	let (
		 n  = replace_all_values (name, value_list=" \t\n\r", new=" ")
		,l_ = split (n, ":")
		,l  =
			[ for (e=l_)
				strip_str (unique (e, f=function(a,b) (a==b && a==" ") ) )
			]
		,s = len(l)
	)
	 s==1 ? [""  , ""  , to_lower_str(l[0])]
	:s==2 ? [l[0], ""  , to_lower_str(l[1])]
	:       [l[0], l[1], to_lower_str(l[2])]
;

function prepare_color_list (list) =
	[ for (e=list) prepare_color_name (e) ]
;
function prepare_color_name (list, version=1) =
	list[color_data_prepared]==true ? list :
	//
	version==0 || version==1 ?
	let(
		// use the first entry in the color data list and count the entries
		color_language_size = len( list[color_data_list][0] ) - 1
	)
	[ for (id=[0:1:3])
		 id==color_data_info ?
			[ for (i=[0:1:3])
				 i==color_info_name ?
					list[color_data_info][i]!=undef ? list[color_data_info][i] : ""
				:i==color_info_shortname ?
					 is_string(list[color_data_info][i]) ? [list[color_data_info][i]] :
					 is_list  (list[color_data_info][i]) ?  list[color_data_info][i]  :
					 []
				:i==color_info_language ?
					// fill all languages
					list[color_data_info][i]==undef ? fill (color_language_size, "") :
					[for (l=[0:1:max (color_language_size-1, len(list[color_data_info][i])-1) ])
						list[color_data_info][i][l]!=undef ? list[color_data_info][i][l] : ""
					]
				:i==color_info_function ?
					list[color_data_info][i]!=undef ? list[color_data_info][i] : undef
				:undef

			]
		:id==color_data_list ?
			version==0 ?
				let (
					name_entries=
					[ for (j=[1:1:len(list[color_data_list][0])-1])
					[ for (k=[0:1:len(list[color_data_list])-1])
						[list[color_data_list][k][0], list[color_data_list][k][j] ]
					]]
				)
				[ for (e=name_entries)
					is_sorted (e, type=[color_entry_name])
					?	e
					:	sort  (e, type=[color_entry_name])
				]
			: // version==1 ?
				let (
					rgb_entries=
					[ for (k=[0:1:len(list[color_data_list])-1])
						[list[color_data_list][k][0] ]
					]
					//
					,name_entries=
					[ for (j=[1:1:len(list[color_data_list][0])-1])
					[ for (k=[0:1:len(list[color_data_list])-1])
						[k, list[color_data_list][k][j] ]
					]]
				)
				[ rgb_entries
				, each
					[for (e=name_entries)
						is_sorted (e, type=[color_entry_name])
						?	e
						:	sort  (e, type=[color_entry_name])
					]
				]
		:id==color_data_prepared ? true
		:id==color_data_version  ? version
		:undef
	]
	:list
;


// convert a rgb color list to a hex value string
function color_list_to_hex (rgb, alpha) =
	rgb[2]==undef ? undef :
	let(
		 r=rgb[0]
		,g=rgb[1]
		,b=rgb[2]
		,a=
			alpha !=undef ? alpha :
			rgb[3]!=undef ? rgb[3] :
			undef
		,hr = value_to_hex (r*255, 2)
		,hg = value_to_hex (g*255, 2)
		,hb = value_to_hex (b*255, 2)
		,ha = a==undef ? undef :
		      value_to_hex (a*255, 2)
	)
	a==undef ?
		str("#", hr, hg, hb)
	:	str("#", hr, hg, hb, ha)
;

// convert a hex color string to a rgb color list
function color_hex_to_list (hex, alpha) =
	let(
		len_hex=len(hex),
		c =
		hex[0]!="#" ? undef
		// r - red
		// g - green
		// b - blue
		// a - alpha
		:len_hex==4 ? // "#rgb"
			[
				hex_letter_to_value (hex, 1, error=0),
				hex_letter_to_value (hex, 2, error=0),
				hex_letter_to_value (hex, 3, error=0)
			] / 15
		:len_hex==5 ? // "#rgba"
			[
				hex_letter_to_value (hex, 1, error=0),
				hex_letter_to_value (hex, 2, error=0),
				hex_letter_to_value (hex, 3, error=0),
				alpha!=undef ? alpha * 15 :
				hex_letter_to_value (hex, 4, error=15)
			] / 15
		:len_hex==7 ? // "#rrggbb"
			[
				hex_to_value (hex, 1, 2, error=0),
				hex_to_value (hex, 3, 2, error=0),
				hex_to_value (hex, 5, 2, error=0)
			] / 255
		:len_hex==9 ? // "#rrggbbaa"
			[
				hex_to_value (hex, 1, 2, error=0),
				hex_to_value (hex, 3, 2, error=0),
				hex_to_value (hex, 5, 2, error=0),
				alpha!=undef ? alpha * 255 :
				hex_to_value (hex, 7, 2, error=255)
			] / 255
		:undef
	)
	c==undef ? undef :
	alpha!=undef && len(c)==3 ? concat (c, alpha) :
	c
;

// return the brightness of a color from rgb list
//
// rgb - as list [r, g, b]
//   r = red:   0...1
//   g = green: 0...1
//   b = blue:  0...1
// gamma - the gamma correctur factor
//   by gefault 1, but a typical value for monitors is 2.2
//
// return a value of brightness 0...1
//   0 = black
//   1 = white
function color_brightness (rgb, gamma=1) =
	let (
		 r=rgb[0]
		,g=rgb[1]
		,b=rgb[2]
	)
	gamma!=1 ?
		pow (
			  0.299 * pow(r, gamma)
			+ 0.587 * pow(g, gamma)
			+ 0.114 * pow(b, gamma)
		, 1/gamma)
	: // gamma==1
			  0.299 * r
			+ 0.587 * g
			+ 0.114 * b
;

