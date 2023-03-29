// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later

use <banded/helper_native.scad>

//
function summation (list, n, k=0) =
	let (
	last = (n==undef) ? len(list)-1
	       :            min(n, len(list)-1)
	)
	(k>last) ? undef :
	//summation_intern          (list, last, k)
	//summation_intern_1        (list, last, k)
	  summation_intern_generate (list, last, k)
;
function summation_intern_generate (list, n, k) =
	[for (
		i=k, sum=list[n];
		i<=n;
		sum=sum+list[i], i=i+1
		) if (i==n) sum
	] [0]
;
function summation_intern (list, n, k) =
	(k==n) ? list[k]
	:is_split_block(8,n,k) ?
		let (mid_n = split_block(8,n,k))
		summation_intern_8(list, mid_n, k) +
		summation_intern  (list, n,     mid_n+1)
	:
		summation_intern_1(list, n, k+1, list[k])
;
function summation_intern_1 (list, n, k, value=0) =
	(k>n) ? value :
	summation_intern_1(list, n, k+1, value + list[k])
;
function summation_intern_8 (list, n, k) =
    let (
	new_list = [ for (i=[k:8:n-7])
		list[i]   + list[i+1] + list[i+2] + list[i+3] +
		list[i+4] + list[i+5] + list[i+6] + list[i+7]
	] )
	summation_intern (new_list, len(new_list)-1, 0)
;

//
function product (list, n, k=0) =
	let (
	last = (n==undef) ? len(list)-1
	       :            min(n, len(list)-1)
	)
	(k>last) ? undef :
	//product_intern          (list, last, k)
	//product_intern_1        (list, last, k)
	  product_intern_generate (list, last, k)
;
function product_intern_generate (list, n, k) =
	[for (
		i=k, prod=list[n];
		i<=n;
		prod=prod*list[i], i=i+1
		) if (i==n) prod
	] [0]
;
function product_intern (list, n, k) =
	(k==n) ? list[k]
	:is_split_block(8,n,k) ?
		let (mid_n = split_block(8,n,k))
		product_intern_8(list, mid_n, k) *
		product_intern  (list, n,     mid_n+1)
	:
		product_intern_1(list, n, k+1, list[k])
;
function product_intern_1 (list, n, k, value=1) =
	(k>n) ? value :
	product_intern_1(list, n, k+1, value * list[k])
;
function product_intern_8 (list, n, k) =
    let (
	new_list = [ for (i=[k:8:n-7])
		list[i]   * list[i+1] * list[i+2] * list[i+3] *
		list[i+4] * list[i+5] * list[i+6] * list[i+7]
	] )
	product_intern (new_list, len(new_list)-1, 0)
;

// Ergebnis: summation(list)==1
function unit_summation (list) =
	list / summation(list)
;

// Ergebnis: product(list)==1
function unit_product (list) =
	list / pow (product(list), 1/len(list))
;


// Polynomdivision
// Ergebnis: Restpolynom
function polynomial_division (a, b) =
	let (
		size_a = len(a),
		size_b = len(b)
	)
	a[size_a-1]==0 ?
		polynomial_division ([for (i=[0:1:size_a-2]) a[i]], b)
	:
	size_a<size_b  ? a :
	let (
		d    = b * (a[size_a-1] / b[size_b-1]),
		diff = size_a-size_b,
		next = [
			each [for (i=[0:1:diff-1])      a[i] ],
			each [for (i=[diff:1:size_a-2]) a[i]-d[i-diff] ]
			]
	)
	polynomial_division (next, b)
;

