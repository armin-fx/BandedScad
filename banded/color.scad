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


color_list =
	[ each is_undef(color_name_svg   ) ? [] : prepare_color_list( color_name_svg    )
	, each is_undef(color_name_banded) ? [] : prepare_color_list( color_name_banded )
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

// return the name of color to rgb value as list
function color_name (name, alpha, colors) =
	name==undef || len(name)<1 ? undef :
	let(
		 a = alpha!=undef ? alpha : 1
		,n = to_lower_str(name)
		,Colors = colors==undef ? color_list : colors
		,p = color_name_find (Colors, n, len(Colors))
		,c = p==undef ? undef
			: (Colors [p[0]] [color_data_list] [p[1]] [p[2]] [color_entry_rgb]) / 255
	)
	c==undef ? undef :
	a==1 ? c
	     : [c[0],c[1],c[2], a]
;
// Rückgabe: [Position der Farbliste, Position der Farbnamenliste, Position der Farbe]
function color_name_find (list, name, s=0, i=0) =
	i>=s ? undef :
	let (
		res = color_name_find_entry (list[i][color_data_list], name, len(list[i][color_data_list]))
	)
	res==undef
		? color_name_find (list, name, s, i+1)
		: [ i, res[0], res[1] ]
;
function color_name_find_entry (list, name, s=0, j=0) =
	j>=s ? undef :
	let (
		res = binary_search (list[j], name, [color_entry_name])
	)
	res<0
		? color_name_find_entry (list, name, s, j+1)
		: [j, res]
;

function prepare_color_list (list) =
	[ for (e=list) prepare_color_name (e) ]
;
function prepare_color_name (list) =
	list[color_data_prepared]==true ? list :
	[ for (i=[0:1:max (2 , len(list)-1 )])
		 i==color_data_info ? list[color_data_info]
		:i==color_data_list ?
			let (
				name_entries=
				[ for (j=[1:1:len(list[color_data_list][0])-1])
				[ for (k=[0:1:len(list[color_data_list])-1])
					[list[color_data_list][k][0], list[color_data_list][k][j] ]
				]]
			)
			[for (e=name_entries)
				is_sorted (e, type=[color_entry_name])
				?	e
				:	sort  (e, type=[color_entry_name])
			]
		:i==color_data_prepared ? true
		:undef
	]
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

