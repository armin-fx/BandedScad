// constants.scad
//
// definiert einige Konstanten

include <tools/constants_helper.scad>


// Zahl zum addieren/subtrahieren,
// falls Objekte zum Ausschneiden etwas größer sein müssen wegen Z-fighting
extra=0.02;

// kleinste Zahl zum addieren/subtrahieren
// z.B wenn sich 2 Objekte eine Ecke teilen und deshalb Fehler erzeugen
//epsilon=0.00005;
epsilon=  0.000075;

// Konstante pi = 3.14159265359
pi  = calculate_pi( function_find_first(check_accuracy_pi, true, 21));
tau = 2*pi;
// Eulersche Zahl = 2.71828182846
euler  = exp(1);
// Euler-Mascheroni-Konstante = 0.577215664901
euler_mascheroni = 0 + 0.577215664901;
// Goldener Schnitt = 1.61803398875
golden = (1 + sqrt(5)) / 2;

// Maßeinheiten umrechnen
mm_per_inch = 0 + 25.4;
degree_per_radian = 180/pi;
percent = 0 + 0.01;
//
// Lichtgeschwindigkeit in m/s
lightspeed = 0 + 299792458;

