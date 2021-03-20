// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later

// Function literal 'fn' with each element in list
// since OpenSCAD Version 2021.01
function fn_each   (list, fn) = [for (a=list) fn(a)];
function fn_2_each (list1, list2, fn) =
	[ for (i=[0:min(len(list1),len(list2))-1])
		fn(list1[i],list2[i])
	]
;

function sqr_each   (list) = [for (a=list) a*a];
function sqrt_each  (list) = [for (a=list) sqrt(a)];
function ln_each    (list) = [for (a=list) ln(a)];
function log_each   (list) = [for (a=list) log(a)];
function exp_each   (list) = [for (a=list) exp(a)];
function pow_each (base,exponent) =
	is_list(base) && is_list(exponent) ?
		[ for (i=[0:min(len(base),len(exponent))-1])
			is_list(base[i]) || is_list(exponent[i]) ?
			    pow_each (base[i], exponent[i])
			:   pow      (base[i], exponent[i])
		]
	: is_list(base)     ? [for (a=base)     pow(a,exponent)]
	: is_list(exponent) ? [for (a=exponent) pow(base,a)]
	: pow(base,exponent)
;
function sin_each   (list) = [for (a=list) sin(a)];
function cos_each   (list) = [for (a=list) cos(a)];
function tan_each   (list) = [for (a=list) tan(a)];
function asin_each  (list) = [for (a=list) asin(a)];
function acos_each  (list) = [for (a=list) acos(a)];
function atan_each  (list) = [for (a=list) atan(a)];
function atan2_each (list_y,list_x) =
	is_list(list_y) && is_list(list_x) ?
		[ for (i=[0:min(len(list_y),len(list_x))-1])
			is_list(list_y[i]) || is_list(list_x[i]) ?
			    atan2_each (list_y[i], list_x[i])
			:   atan2      (list_y[i], list_x[i])
		]
	: is_list(list_y) ? [for (a=list_y) atan2(a,list_x)]
	: is_list(list_x) ? [for (a=list_x) atan2(list_y,a)]
	: atan2(list_y,list_x)
;
function floor_each (list) = [for (a=list) floor(a)];
function ceil_each  (list) = [for (a=list) ceil(a)];
function round_each (list) = [for (a=list) round(a)];
function abs_each   (list) = [for (a=list) abs(a)];

function reciprocal_each (list) = [for (a=list) 1/a];

function multiply_each (list1, list2) =
	[ for (i=[0:len(list1)-1])
		is_list(list1[i]) ? multiply_each (list1[i], list2[i]) :
		is_list(list2)    ? list1[i] * list2[i]
		:                   list1[i] * list2
	]
;
function divide_each (list1, list2) =
	[ for (i=[0:len(list1)-1])
		is_list(list1[i]) ? divide_each (list1[i], list2[i]) :
		is_list(list2)    ? list1[i] / list2[i]
		:                   list1[i] / list2
	]
;

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
