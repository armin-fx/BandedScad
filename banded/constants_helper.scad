// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Hilfsfunktionen, um Konstanten zu berechnen


function calculate_pi (n=21) =
	4 / calculate_pi_continued_fraction(n)
;
function calculate_pi_continued_fraction (n=21, i=0) =
	let(
	j = i+1,
	b = 2*i + 1,
	a = j*j
	)
	i>=n ? b :
	b + a / calculate_pi_continued_fraction(n, i+1)
;

function get_max_accuracy_pi (n=21, pi1=0, pi2=1) =
	(pi1==pi2) ?
		pi1
	:	get_max_accuracy_pi(n+1, pi2, calculate_pi(n))
;
function check_accuracy_pi (n=21) = calculate_pi(n)==calculate_pi(n+1);

function calculate_golden () = (1 + sqrt(5)) / 2;

// Errechnet die Maschinengenauigkeit von Fließkommazahlen
// Mit 'fn' kann optional ein Funktionsliteral angegeben werden,
// dessen Rechengenauigkeit ermittelt werden soll.
function machine_epsilon (fn, e=1) =
	fn==undef
		? machine_epsilon_direct(e)
		: machine_epsilon_function(fn, e)
;
function machine_epsilon_direct (e=1) =
	(1 + e) == 1 ? e :
	machine_epsilon_direct (e*0.5)
;
function machine_epsilon_function (fn, e=1) =
	(1 + fn(e)) == 1 ? e :
	machine_epsilon_function (fn, e*0.5)
;
