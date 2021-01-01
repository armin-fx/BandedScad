// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Operatoren zum Platzieren von Objekten

use <tools/math_vector.scad>
use <tools/draft_transform_common.scad>
use <tools/draft_transform_basic.scad>
use <tools/operator_transform.scad>

// bewegt und dreht das Objekt zum angegebenen Ort
// Der Punkt im Koordinatenursprung wird nach point bewegt
// Die Z-Achse ist die Pfeilrichtung, wird nach 'direction' gedreht,
// Die X-Achse ist die Rotationsrichtung, wird um die Pfeilrichtung nach den Punkt 'rotational' gedreht
module connect (point=[0,0,0], direction=[0,0,1], rotational=[1,0,0])
{
	base_vector = [1,0];
	up_to_z     = rotate_backwards_to_vector_list ( [rotational], direction);
	plane       = projection_list (up_to_z);
	angle_base  = rotation_vector (base_vector, plane[0]);
	//
	translate (point)
	rotate_to_vector (direction, angle_base)
	children();
}

// Platziert ein Objekt an den angegebenen Punkten in der Liste
module place (points)
{
	for (p=points)
		translate (p)
		children();
}
// Platziert ein Objekt entlang der angegebenen Richtung an den angegebenen Entfernungen
module place_line(direction, distances)
{
	Direction = unit_vector(
		(is_list(direction) && len(direction)>1) ?
			direction
		:	[0,0,1]
	);
	//
	for (l=distances)
		translate (l*Direction)
		children();
}
// Platziert ein Objekt entlang der entsprechenden Achse an den angegebenen Entfernungen
module place_x (distances)
{
	for (l=distances)
		translate_x (l)
		children();
}
module place_y (distances)
{
	for (l=distances)
		translate_y (l)
		children();
}
module place_z (distances)
{
	for (l=distances)
		translate_z (l)
		children();
}
