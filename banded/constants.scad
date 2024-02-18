// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// definiert einige Konstanten

use <banded/constants_helper.scad>

include <banded/constants_user.scad>
include <banded/constants_technical.scad>


// - Mathematische Konstanten:

// Konstante PI = 3.14159265359 ist in OpenSCAD integriert
tau = 2*PI;
// Eulersche Zahl = 2.71828182846
euler = exp(1);
// Euler-Mascheroni-Konstante = 0.577215664901
euler_mascheroni = 0.577215664901;
// Goldener Schnitt = 1.61803398875
golden = calculate_golden();

// - Maßeinheiten umrechnen:

mm_per_inch = 25.4;
inch_per_mm = 1 / mm_per_inch;
mm_per_foot = 25.4*12;
foot_per_mm = 1 / mm_per_foot;
mm_per_yard = 25.4*12*3;
yard_per_mm = 1 / mm_per_yard;
degree_per_radian = 180/PI;
radian_per_degree = PI/180;
percent  = 1/100;
permille = 1/1000;
ppm      = 1/1000000;

// - Naturkonstanten:

// Lichtgeschwindigkeit in m/s
lightspeed = 299792458;
// Plancksches Wirkungsquantum in J*s
planck = 6.62607015E-34;
// Boltzmann-Konstante in J/K
boltzmann = 1.380649E-23;
// Elementarladung in C
elementary_charge = 1.602176634E-19;
// Avogadro-Konstante in 1/mol
avogadro = 6.02214076E-23;
// Frequenz der Strahlung des Caesium-Atoms in 1/s
caesium_frequency = 9192631770;

// - Hilfskonstanten:

// Wert unendlich
inf = 1e200 * 1e200;
// Wert keine gültige Zahl
nan = 0 / 0;

// returns a vector with named axis
// d - count of dimensions (2D plane = 2; 3D room, standard = 3)
function x (d=3) = axis (0,d);
function y (d=3) = axis (1,d);
function z (d=3) = axis (2,d);
function origin (d=3, v=0) =
	d==3 ? [v,v,v] :
	d==2 ? [v,v] :
	d==4 ? [v,v,v,v] :
	[for (i=[0:1:d]) v]
;

// predefined 3D axis vector constants
X=x(); Y=y(); Z=z();
O=origin();
A=origin(v=1);

// returns a vector with axis n
// n - number of axis (X=0, Y=1, Z=2)
// d - count of dimensions (2D plane = 2; 3D room, standard = 3)
function axis (n=0, d=3) =
	d<=n || n<0 ? undef :
	d==3 ?
		n==0 ? [1,0,0] :
		n==1 ? [0,1,0] :
		n==2 ? [0,0,1] :
		[0,0,0] :
	d==2 ?
		n==0 ? [1,0] :
		n==1 ? [0,1] :
		[0,0] :
	[ for (i=[0:d-1]) i==n ? 1 : 0 ]
;

// - Test der Konstanten:

// Meldung ausgeben, wenn die Konstanten überschrieben worden sind
message_constants = test_message_constants();
if (version_num()<20190500) test_message_constants ();

function test_message_constants () =
	version_num()<20190500 ? false :
	is_undef(message_constants) ?
		let( s = test_message_constants_str() )
		s!="" ?
			test_message_constants_echo(
			test_message_constants_console(s)
			)
		:	true
	:	false
;
function test_message_constants_echo (s) = echo(s) + false;
function test_message_constants_console (s) =
	version_num()>=20210100 ?
	str ( "\n", s )
	:
	str (
		"<span style=\"background-color:yellow\">\n",
		s,
		"</span>"
	)
;
function test_message_constants_str() = str (
	PI  == get_max_accuracy_pi()       ? "" : "WARNING: Constant 'PI' has changed.\n",
	tau == 2*PI                        ? "" : "WARNING: Constant 'tau' has changed.\n",
	euler == exp(1)                    ? "" : "WARNING: Constant 'euler' has changed.\n",
	euler_mascheroni == 0.577215664901 ? "" : "WARNING: Constant 'euler_mascheroni' has changed.\n",
	golden == calculate_golden()       ? "" : "WARNING: Constant 'golden' has changed.\n",
	//
	mm_per_inch ==    25.4       ? "" : "WARNING: Constant 'mm_per_inch' has changed.\n",
	inch_per_mm == 1/ 25.4       ? "" : "WARNING: Constant 'inch_per_mm' has changed.\n",
	mm_per_foot ==    25.4*12    ? "" : "WARNING: Constant 'mm_per_foot' has changed.\n",
	foot_per_mm == 1/(25.4*12)   ? "" : "WARNING: Constant 'foot_per_mm' has changed.\n",
	mm_per_yard ==    25.4*12*3  ? "" : "WARNING: Constant 'mm_per_yard' has changed.\n",
	yard_per_mm == 1/(25.4*12*3) ? "" : "WARNING: Constant 'yard_per_mm' has changed.\n",
	degree_per_radian == 180/PI  ? "" : "WARNING: Constant 'degree_per_radian' has changed.\n",
	radian_per_degree == PI/180  ? "" : "WARNING: Constant 'radian_per_degree' has changed.\n",
	percent  == 1/100            ? "" : "WARNING: Constant 'percent' has changed.\n",
	permille == 1/1000           ? "" : "WARNING: Constant 'permille' has changed.\n",
	ppm      == 1/1000000        ? "" : "WARNING: Constant 'ppm' has changed.\n",
	//
	lightspeed        == 299792458       ? "" : "WARNING: Constant 'lightspeed' has changed. Welcome to a different world!\n",
	planck            == 6.62607015E-34  ? "" : "WARNING: Constant 'planck' has changed. Welcome to a different world!\n",
	boltzmann         == 1.380649E-23    ? "" : "WARNING: Constant 'boltzmann' has changed. Welcome to a different world!\n",
	elementary_charge == 1.602176634E-19 ? "" : "WARNING: Constant 'elementary_charge' has changed. Welcome to a different world!\n",
	avogadro          == 6.02214076E-23  ? "" : "WARNING: Constant 'avogadro' has changed. Welcome to a different world!\n",
	caesium_frequency == 9192631770      ? "" : "WARNING: Constant 'caesium_frequency' has changed. Welcome to a different world!\n",
	//
	inf == 1e200 * 1e200 ? "" : "WARNING: Constant 'inf' has changed. Chuck Norris counted 2 times to infinity.\n",
	nan != nan           ? "" : "WARNING: Constant 'nan' has changed.\n",
	X == x()         ? "" : "WARNING: Constant 'X' has changed.\n",
	Y == y()         ? "" : "WARNING: Constant 'Y' has changed.\n",
	Z == z()         ? "" : "WARNING: Constant 'Z' has changed.\n",
	O == origin()    ? "" : "WARNING: Constant 'O' has changed.\n",
	A == origin(v=1) ? "" : "WARNING: Constant 'A' has changed.\n",
	"")
;

module test_message_constants ()
{
	s = test_message_constants_str();
	if (s!="") echo( test_message_constants_console(s) );
}
