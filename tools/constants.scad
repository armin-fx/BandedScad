// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// definiert einige Konstanten

//include <tools/constants_helper.scad>


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
euler_mascheroni = 0 + 0.577215664901;
// Goldener Schnitt = 1.61803398875
golden = (1 + sqrt(5)) / 2;

// Maßeinheiten umrechnen
mm_per_inch = 0 + 25.4;
degree_per_radian = 180/PI;
percent = 0 + 0.01;
//
// Lichtgeschwindigkeit in m/s
lightspeed = 0 + 299792458;

