// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält mathematische Funktionen,
// die auf die einzelnen Werte in der gesamten Liste angewendet werden.

use <banded/math_common.scad>


// Function literal 'fn' with each element in list
// since OpenSCAD Version 2021.01
function fn_each   (list, fn) = [for (a=list) fn(a)];
function fn_2_each (list1, list2, fn) =
	[ for (i=[0:1:min(len(list1),len(list2))-1])
		fn (list1[i],list2[i])
	]
;
function fn_2_each_with (list, value, fn) =
	[ for (i=[0:1:len(list)-1])
		fn (list[i],value)
	]
;

function sqr_each   (list) = [for (a=list) a*a];
function sqrt_each  (list) = [for (a=list) sqrt(a)];
function ln_each    (list) = [for (a=list) ln(a)];
function log_each   (list) = [for (a=list) log(a)];
function exp_each   (list) = [for (a=list) exp(a)];
function pow_each (base, exponent) =
	[ for (i=[0:1:min(len(base),len(exponent))-1]) pow (base[i], exponent[i]) ]
;
function pow_each_with_base     (base, exponent) = [ for (a=exponent) pow (base,a)     ];
function pow_each_with_exponent (base, exponent) = [ for (a=base)     pow (a,exponent) ];
//
function sin_each   (list) = [for (a=list) sin(a)];
function cos_each   (list) = [for (a=list) cos(a)];
function tan_each   (list) = [for (a=list) tan(a)];
function cot_each   (list) = [for (a=list) cot(a)];
function sec_each   (list) = [for (a=list) sec(a)];
function csc_each   (list) = [for (a=list) csc(a)];
function exsec_each (list) = [for (a=list) exsec(a)];
function excsc_each (list) = [for (a=list) excsc(a)];
function versin_each   (list) = [for (a=list) versin  (a)];
function coversin_each (list) = [for (a=list) coversin(a)];
function vercos_each   (list) = [for (a=list) vercos  (a)];
function covercos_each (list) = [for (a=list) covercos(a)];
function chord_each (list) = [for (a=list) chord(a)];
function asin_each  (list) = [for (x=list) asin(x)];
function acos_each  (list) = [for (x=list) acos(x)];
function atan_each  (list) = [for (x=list) atan(x)];
function atan2_each (list_y,list_x) =
	[ for (i=[0:1:min(len(list_y),len(list_x))-1]) atan2 (list_y[i], list_x[i]) ]
;
function atan2_each_with_x (list_y,x) = [ for (v=list_y) atan2 (v,x) ];
function atan2_each_with_y (y,list_x) = [ for (v=list_x) atan2 (y,v) ];
function acot_each  (list) = [for (x=list) acot(x)];
function asec_each  (list) = [for (x=list) asec(x)];
function acsc_each  (list) = [for (x=list) acsc(x)];
function aexsec_each (list) = [for (x=list) aexsec(x)];
function aexcsc_each (list) = [for (x=list) aexcsc(x)];
function aversin_each   (list) = [for (x=list) aversin  (x)];
function acoversin_each (list) = [for (x=list) acoversin(x)];
function avercos_each   (list) = [for (x=list) avercos  (x)];
function acovercos_each (list) = [for (x=list) acovercos(x)];
function achord_each (list) = [for (x=list) achord(x)];
//
function sinh_each  (list) = [for (e=list) sinh(e)];
function cosh_each  (list) = [for (e=list) cosh(e)];
function tanh_each  (list) = [for (e=list) tanh(e)];
function coth_each  (list) = [for (e=list) coth(e)];
function asinh_each (list) = [for (e=list) asinh(e)];
function acosh_each (list) = [for (e=list) acosh(e)];
function atanh_each (list) = [for (e=list) atanh(e)];
function acoth_each (list) = [for (e=list) acoth(e)];
//
function floor_each (list) = [for (a=list) floor(a)];
function ceil_each  (list) = [for (a=list) ceil(a)];
function round_each (list) = [for (a=list) round(a)];
function abs_each   (list) = [for (a=list) abs(a)];

function add_each_with (list, value)         = [ for (e=list) e + value ];
function sub_each_with (list, value)         = [ for (e=list) e - value ];

function multiply_each (list1, list2) =
	[ for (i=[0:1:min(len(list1),len(list2))-1]) list1[i] * list2[i] ]
;
function divide_each (list1, list2) =
	[ for (i=[0:1:min(len(list1),len(list2))-1]) list1[i] / list2[i] ]
;
function multiply_each_with (list, value)    = [ for (e=list) e * value ];
function multiply_with_each (value, list)    = [ for (e=list) value * e ];
function divide_each_with   (list, value)    = [ for (e=list) e / value ];
function reciprocal_each (list, numerator=1) = [ for (e=list) numerator / e];

function norm_each (list) = [for (a=list) norm(a)];

function sum_each_next (list, begin=0, offset=0) =
	!(begin<=len(list)-1) ? undef :
	//sum_each_next_intern (list, begin, offset)
	[ for (i=begin,o=offset; i<=len(list); o=o+(list[i]!=undef ? list[i] : 0),i=i+1) o ]
;
function sum_each_next_intern (list, begin=0, offset=0) =
	begin==len(list) ? offset :
	concat(offset, sum_each_next_intern(list, begin+1, offset+list[begin]))
;

function quantize_each (list, raster=1, offset=0.5) = [for (e=list) quantize (e, raster, offset)];

function mod_each (list, n) = [for (e=list) (e%n+n)%n];

function constrain_each       (list, min, max) = [for (e=list) constrain       (e, min, max)];
function constrain_range_each (list, a  , b  ) = [for (e=list) constrain_range (e, a  , b  )];


// - For a list with lists:

function add_all_each_with      (list, value)    = [ for (l=list) [ for (e=l) e + value ] ];
function sub_all_each_with      (list, value)    = [ for (l=list) [ for (e=l) e - value ] ];
function multiply_all_each_with (list, value)    = [ for (l=list) [ for (e=l) e * value ] ];
function divide_all_each_with   (list, value)    = [ for (l=list) [ for (e=l) e / value ] ];
function reciprocal_all_each (list, numerator=1) = [ for (l=list) [ for (e=l) numerator / e] ];

