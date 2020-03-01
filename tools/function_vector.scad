// function_vector.scad 
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
// Hilfsfunktionen:

// Vektor normieren auf die Länge 1
function norm_vector (v) = v / norm(v);

// Winkel zweier Vektoren ermitteln
function angle_vector (v1, v2) =
	(v1==v2) ? 0 :
	acos( (v1 * v2) / (norm(v1) * norm(v2)) )
;
function angle_left_vector (v1, v2) =
	(v1==v2) ? 0 :
	(cross(v1,v2) >= 0) ?
		      acos( (v1 * v2) / (norm(v1) * norm(v2)) )
	:	360 - acos( (v1 * v2) / (norm(v1) * norm(v2)) )
;
function angle_right_vector (v1, v2) = 360 - angle_left_vector(v1, v2);
function rotation_vector (v1, v2) = angle_left_vector (v1, v2);

function get_connect_data (point=[0,0,0], vector=[0,0,1], text) = [point, vector, text];
//
module connect (point=[0,0,0], vector=[0,0,1], text, show=false, data)
{
	
}

