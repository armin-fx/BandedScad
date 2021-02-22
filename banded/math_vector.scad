// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Hilfsfunktionen, zum Arbeiten mit Vektoren
//
//
// Hilfsfunktionen enthalten in OpenScad:
//
// norm()   - Betrag eines Vektors = die Länge des Vektors
// a[]+b[]  - Vektorielle Addition / Subtraktion
// a[]*b[]  - Skalarprodukt
// cross()  - Kreuzprodukt (Vektorielles Produkt)
//


// Vektor normieren auf die Länge 1
function unit_vector (v) = v / norm(v);

// eingeschlossenen Winkel zweier Vektoren ermitteln
function angle_vector (v1, v2) =
	acos( (v1 * v2) / (norm(v1) * norm(v2)) )
;
// Winkel zweier Vektoren in der Ebene ermitteln entsprechend seiner Rotation
// gerechnet wird mit Linksrotation = gegen den Uhrzeigersinn
// wie in der Mathematik üblich
// Im 3D-Raum wird wie bei angle_vector() der eingeschlossene Winkel
// zurückgegeben. Die Rotationsachse kann über das Kreuzprodukt ermitelt werden.
function rotation_vector (v1, v2) = angle_left_vector (v1, v2);
function angle_left_vector (v1, v2) =
	(len(v1)!=2) || (cross(v1,v2) >= 0) ?
		      acos( (v1 * v2) / (norm(v1) * norm(v2)) )
	:	360 - acos( (v1 * v2) / (norm(v1) * norm(v2)) )
;
function angle_right_vector (v1, v2) = 360 - angle_left_vector(v1, v2);

// rechnet das Spatprodukt aus
function triple_product (a, b, c) = a * cross(b, c) ;

