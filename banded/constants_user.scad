// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// definiert einige benutzerdefinierbare Konstanten
// Diese können an den Bedarf angepasst werden

use <banded/constants_helper.scad>


// Zahl zum addieren/subtrahieren,
// falls Objekte zum Ausschneiden etwas größer sein müssen wegen Z-fighting
extra=0.02;

// kleinste Zahl zum addieren/subtrahieren
// z.B wenn sich 2 Objekte eine Ecke teilen und deshalb Fehler erzeugen
//epsilon=0.00005;
epsilon=  0.000075;

// kleinste Zahl, die bei Rechenungenauigkeiten auftritt
deviation=1e-14;
deviation_sqr = machine_epsilon (function(x) x*x);

// Schrittweite für Infinitsimalrechnung
delta_std = 0.001;

