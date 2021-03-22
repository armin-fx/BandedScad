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

// Return the angle around vector 'v' from points 'p1' to 'p2' in
// mathematical direction = counter clockwise.
// This is the angle you see if you show into the vector 'v' from the upper side,
// from point 'p1' to 'p2'.
// v  = vector, line defined from origin to this point
// p1 = first point, rotate begin
// p2 = second point, rotate end
function rotation_around_vector (v, p1, p2) =
	let(
		// u=rotate_backwards_to_vector_points([p1,p2], v),
		// q=projection_points(u),
		// a=rotation_vector (q[0], q[1])
		//
		nz_=v.z/norm(v),
		nz =is_num(nz_) ? nz_ : 1,
		//b=-acos(nz),       // inclination angle
		c=-atan2(v.y,v.x), // azimuthal angle
		//
		sinb  = -sqrt(1-nz*nz),
		cosb  = nz,
		sinc  = sin(c),
		cosc  = cos(c),
		//
		q1=[ (p1.x*cosc - p1.y*sinc)*cosb + p1.z*sinb
		    , p1.x*sinc + p1.y*cosc ],
		q2=[ (p2.x*cosc - p2.y*sinc)*cosb + p2.z*sinb
		    , p2.x*sinc + p2.y*cosc ],
		//
		a=angle_left_vector (q1, q2)
	)
	a
;

// Get angle around line from points 'p1' to 'p2'
// line = 2 point list, line defined from first point to second point
// p1   = first point, rotate begin
// p2   = second point, rotate end
function rotation_around_line (line, p1, p2) =
	rotation_around_vector (
		line[1]-line[0],
		p1     -line[0],
		p2     -line[0])
;

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

