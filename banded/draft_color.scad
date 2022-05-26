// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//

use <banded/string.scad>
use <banded/list_edit_data.scad>


// transform color from hsv model to rgb model
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
		,n = to_lower_case(name)
		,p = binary_search (color_name_list, n, [1])
	)
	p<0 ? undef :
	let(
		 c = color_name_list[p][0] / 255
	)
	a==1 ? c
	:          concat (c, a)
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

// list of names of color
// Color names are taken from the World Wide Web consortium's SVG color list
color_name_list = sort (type=[1], list=[
	[[240,248,255], "aliceblue"],
	[[250,235,215], "antiquewhite"],
	[[  0,255,255], "aqua"],
	[[127,255,212], "aquamarine"],
	[[240,255,255], "azure"],
	[[245,245,220], "beige"],
	[[255,228,196], "bisque"],
	[[  0,  0,  0], "black"],
	[[255,235,205], "blanchedalmond"],
	[[  0,  0,255], "blue"],
	[[138, 43,226], "blueviolet"],
	[[165, 42, 42], "brown"],
	[[222,184,135], "burlywood"],
	[[ 95,158,160], "cadetblue"],
	[[127,255,  0], "chartreuse"],
	[[210,105, 30], "chocolate"],
	[[255,127, 80], "coral"],
	[[100,149,237], "cornflowerblue"],
	[[255,248,220], "cornsilk"],
	[[220, 20, 60], "crimson"],
	[[  0,255,255], "cyan"],
	[[  0,  0,139], "darkblue"],
	[[  0,139,139], "darkcyan"],
	[[184,134, 11], "darkgoldenrod"],
	[[169,169,169], "darkgray"],
	[[  0,100,  0], "darkgreen"],
	[[169,169,169], "darkgrey"],
	[[189,183,107], "darkkhaki"],
	[[139,  0,139], "darkmagenta"],
	[[ 85,107, 47], "darkolivegreen"],
	[[255,140,  0], "darkorange"],
	[[153, 50,204], "darkorchid"],
	[[139,  0,  0], "darkred"],
	[[233,150,122], "darksalmon"],
	[[143,188,143], "darkseagreen"],
	[[ 72, 61,139], "darkslateblue"],
	[[ 47, 79, 79], "darkslategray"],
	[[ 47, 79, 79], "darkslategrey"],
	[[  0,206,209], "darkturquoise"],
	[[148,  0,211], "darkviolet"],
	[[255, 20,147], "deeppink"],
	[[  0,191,255], "deepskyblue"],
	[[105,105,105], "dimgray"],
	[[105,105,105], "dimgrey"],
	[[ 30,144,255], "dodgerblue"],
	[[178, 34, 34], "firebrick"],
	[[255,250,240], "floralwhite"],
	[[ 34,139, 34], "forestgreen"],
	[[255,  0,255], "fuchsia"],
	[[220,220,220], "gainsboro"],
	[[248,248,255], "ghostwhite"],
	[[255,215,  0], "gold"],
	[[218,165, 32], "goldenrod"],
	[[128,128,128], "gray"],
	[[  0,128,  0], "green"],
	[[173,255, 47], "greenyellow"],
	[[128,128,128], "grey"],
	[[240,255,240], "honeydew"],
	[[255,105,180], "hotpink"],
	[[205, 92, 92], "indianred"],
	[[ 75,  0,130], "indigo"],
	[[255,255,240], "ivory"],
	[[240,230,140], "khaki"],
	[[230,230,250], "lavender"],
	[[255,240,245], "lavenderblush"],
	[[124,252,  0], "lawngreen"],
	[[255,250,205], "lemonchiffon"],
	[[173,216,230], "lightblue"],
	[[240,128,128], "lightcoral"],
	[[224,255,255], "lightcyan"],
	[[250,250,210], "lightgoldenrodyellow"],
	[[211,211,211], "lightgray"],
	[[144,238,144], "lightgreen"],
	[[211,211,211], "lightgrey"],
	[[255,182,193], "lightpink"],
	[[255,160,122], "lightsalmon"],
	[[ 32,178,170], "lightseagreen"],
	[[135,206,250], "lightskyblue"],
	[[119,136,153], "lightslategray"],
	[[119,136,153], "lightslategrey"],
	[[176,196,222], "lightsteelblue"],
	[[255,255,224], "lightyellow"],
	[[  0,255,  0], "lime"],
	[[ 50,205, 50], "limegreen"],
	[[250,240,230], "linen"],
	[[255,  0,255], "magenta"],
	[[128,  0,  0], "maroon"],
	[[102,205,170], "mediumaquamarine"],
	[[  0,  0,205], "mediumblue"],
	[[186, 85,211], "mediumorchid"],
	[[147,112,219], "mediumpurple"],
	[[ 60,179,113], "mediumseagreen"],
	[[123,104,238], "mediumslateblue"],
	[[  0,250,154], "mediumspringgreen"],
	[[ 72,209,204], "mediumturquoise"],
	[[199, 21,133], "mediumvioletred"],
	[[ 25, 25,112], "midnightblue"],
	[[245,255,250], "mintcream"],
	[[255,228,225], "mistyrose"],
	[[255,228,181], "moccasin"],
	[[255,222,173], "navajowhite"],
	[[  0,  0,128], "navy"],
	[[253,245,230], "oldlace"],
	[[128,128,  0], "olive"],
	[[107,142, 35], "olivedrab"],
	[[255,165,  0], "orange"],
	[[255, 69,  0], "orangered"],
	[[218,112,214], "orchid"],
	[[238,232,170], "palegoldenrod"],
	[[152,251,152], "palegreen"],
	[[175,238,238], "paleturquoise"],
	[[219,112,147], "palevioletred"],
	[[255,239,213], "papayawhip"],
	[[255,218,185], "peachpuff"],
	[[205,133, 63], "peru"],
	[[255,192,203], "pink"],
	[[221,160,221], "plum"],
	[[176,224,230], "powderblue"],
	[[128,  0,128], "purple"],
	[[255,  0,  0], "red"],
	[[188,143,143], "rosybrown"],
	[[ 65,105,225], "royalblue"],
	[[139, 69, 19], "saddlebrown"],
	[[250,128,114], "salmon"],
	[[244,164, 96], "sandybrown"],
	[[ 46,139, 87], "seagreen"],
	[[255,245,238], "seashell"],
	[[160, 82, 45], "sienna"],
	[[192,192,192], "silver"],
	[[135,206,235], "skyblue"],
	[[106, 90,205], "slateblue"],
	[[112,128,144], "slategray"],
	[[112,128,144], "slategrey"],
	[[255,250,250], "snow"],
	[[  0,255,127], "springgreen"],
	[[ 70,130,180], "steelblue"],
	[[210,180,140], "tan"],
	[[  0,128,128], "teal"],
	[[216,191,216], "thistle"],
	[[255, 99, 71], "tomato"],
	[[ 64,224,208], "turquoise"],
	[[238,130,238], "violet"],
	[[245,222,179], "wheat"],
	[[255,255,255], "white"],
	[[245,245,245], "whitesmoke"],
	[[255,255,  0], "yellow"],
	[[154,205, 50], "yellowgreen"]
]);

