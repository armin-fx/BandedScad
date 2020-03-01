// constants.scad
//
// Hilfsfunktionen, um Konstanten zu berechnen


function calculate_pi (num=21) =
	4/continued_fraction(
		[ for (i=[0:num]) 2*i + 1 ] ,
		[ for (i=[1:num]) i*i     ] )
;
function check_accuracy_pi(num=21) = calculate_pi(num)==calculate_pi(num+1);
check_accuracy_pi=str("check_accuracy_pi");

