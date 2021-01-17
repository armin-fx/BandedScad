// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// definiert einige Konstanten

//use <banded/constants_helper.scad>


// Zahl zum addieren/subtrahieren,
// falls Objekte zum Ausschneiden etwas größer sein müssen wegen Z-fighting
extra=0.02;

// kleinste Zahl zum addieren/subtrahieren
// z.B wenn sich 2 Objekte eine Ecke teilen und deshalb Fehler erzeugen
//epsilon=0.00005;
epsilon=  0.000075;

// Wert unendlich
inf = 1e200 * 1e200;
// Wert keine gültige Zahl
nan = 0 / 0;

// Konstante PI = 3.14159265359 ist in OpenSCAD integriert
tau = 2*PI;
// Eulersche Zahl = 2.71828182846
euler = exp(1);
// Euler-Mascheroni-Konstante = 0.577215664901
euler_mascheroni = 0.577215664901;
// Goldener Schnitt = 1.61803398875
golden = (1 + sqrt(5)) / 2;

// Maßeinheiten umrechnen
mm_per_inch = 25.4;
degree_per_radian = 180/PI;
percent = 0.01;
//
// Lichtgeschwindigkeit in m/s
lightspeed = 299792458;


// Meldung ausgeben, wenn die Konstanten überschrieben worden sind
message_constants = test_message_constants();
function test_message_constants () =
	version_num()<20190500 ? false :
	is_undef(message_constants) ?
		let( s = test_message_constants_str() )
		s!="" ?
			test_message_constants_echo( test_message_constants_console(s) )
		:	true
	:	false
;
function test_message_constants_echo (s) = echo(s) + false;
function test_message_constants_console (s) =
	str (
		"<span style=\"background-color:yellow\">\n",
		s,
		"</span>"
	)
;
function test_message_constants_str() = str (
	inf == 1e200 * 1e200 ? "" : "WARNING: Constant 'inf' has changed.\n",
	nan != nan           ? "" : "WARNING: Constant 'nan' has changed.\n",
	tau == 2*PI          ? "" : "WARNING: Constant 'tau' has changed.\n",
	euler == exp(1)      ? "" : "WARNING: Constant 'euler' has changed.\n",
	euler_mascheroni == 0.577215664901 ? "" :
		"WARNING: Constant 'euler_mascheroni' has changed.\n",
	golden == (1 + sqrt(5)) / 2 ? "" : "WARNING: Constant 'golden' has changed.\n",
	mm_per_inch == 25.4         ? "" : "WARNING: Constant 'mm_per_inch' has changed.\n",
	degree_per_radian == 180/PI ? "" : "WARNING: Constant 'degree_per_radian' has changed.\n",
	percent == 0.01             ? "" : "WARNING: Constant 'percent' has changed.\n",
	lightspeed == 299792458     ? "" : "WARNING: Constant 'lightspeed' has changed. Welcome to a different world!\n",
	"")
;

if (version_num()<20190500)
{
	s = test_message_constants_str();
	if (s!="") echo( test_message_constants_console(s) );
}
