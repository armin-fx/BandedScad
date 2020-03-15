// constants.scad
//
// Hilfsfunktionen, um Konstanten zu berechnen


function calculate_pi (num=21) =
	4/continued_fraction(
		[ for (i=[0:num]) 2*i + 1 ] ,
		[ for (i=[1:num]) i*i     ] )
;
function get_max_accuracy_pi (n=21, pi1=0, pi2=1) =
	(pi1==pi2) ?
		pi1
	:	get_max_accuracy_pi(n+1, pi2, calculate_pi(n))
;
function check_accuracy_pi(num=21) = calculate_pi(num)==calculate_pi(num+1);

