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
// zurückgegeben. Die Rotationsachse kann über das Kreuzprodukt ermittelt werden.
function rotation_vector (v1, v2) = angle_left_vector (v1, v2);
function angle_left_vector (v1, v2) =
	(len(v1)!=2) || (cross(v1,v2) >= 0) ?
		      acos( (v1 * v2) / (norm(v1) * norm(v2)) )
	:	360 - acos( (v1 * v2) / (norm(v1) * norm(v2)) )
;
function angle_right_vector (v1, v2) = 360 - angle_left_vector(v1, v2);

// rechnet das Kreuzprodukt von n-dimensionale Vektoren aus
// mit n-1 Vektoren in einer Liste 'list'
// Besonderheit:
// Verwendet in jeder Dimension das Rechtshandsystem.
// Werden die nachfolgenden n-1 Einheitsvektoren übergeben,
// wird der fehlende letzte Einheitsvektor geliefert.
function cross_universal (list) =
	list==undef ? undef
	: len(list[0])==2 ? [-list[0].y,list[0].x]
	: len(list[0])==3 ? cross(list[0], list[1])
	: len(list[0]) >3 ?
		determinant( concat(
			 [ for (i=[0:1:len(list[0])-2]) list[i] ]
			,[ identity_matrix( len(list[0]) ) ]
		) )
	: undef
;

// rechnet das Spatprodukt aus
function triple_product (a, b, c) = a * cross(b, c) ;

// Wählt aus 3 Vektoren die Reihe nach eine Achse aus
function pick_vector (vx, vy, vz) = [vx.x, vy.y, vz.z] ;

