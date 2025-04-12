// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//

use <banded/string.scad>
use <banded/list_edit_data.scad>
use <banded/list_edit_test.scad>

include <color/color_svg.scad>
include <color/color_other.scad>


// get color as rgb or rgba list
function get_color (c, alpha, default=undef) =
	is_string(c) ?
		c[0]=="#" ?
			color_hex_to_list (c, alpha)
		:	color_name        (c, alpha)
	:is_num(c[2]) ?
		alpha==undef ? c : [c[0],c[1],c[2],alpha]
	:default
;
// module to use extra color names
module color_extend (c, alpha, default=undef)
{
	color (get_color (c, alpha, default) )
	children();
}

// get a color between 'c' and 'c2'
// with t = 0...1  ==> c...c2
function get_color_between (c, c2, t=0.5, alpha) =
	  (1-t) * get_color (c , alpha)
	+ (t  ) * get_color (c2, alpha)
;
module color_between (c, c2, t=0.5, alpha)
{
	color (get_color_between (c, c2, t, alpha) )
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
function color_name (name, alpha) =
	name==undef || len(name)<1 ? undef :
	let(
		 a = alpha!=undef ? alpha : 1
		,n = to_lower_str(name)
		,p =             binary_search (color_name_svg  , n, [1])
		,q = p>=0 ? -1 : binary_search (color_name_other, n, [1])
		,c = p>=0 ? color_name_svg  [p][0] / 255 :
		     q>=0 ? color_name_other[q][0] / 255 :
		     undef
	)
	c==undef ? undef :
	a==1 ? c
	     : [c[0],c[1],c[2], a]
;

function prepare_color_name (list) =
	is_sorted (list, type=[1])
	?	list
	:	sort (list, type=[1])
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

