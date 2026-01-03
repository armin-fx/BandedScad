// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Operatoren zum Platzieren von Objekten

use <banded/math_vector.scad>
use <banded/draft_transform_common.scad>
use <banded/draft_transform_basic.scad>
use <banded/operator_transform.scad>

// bewegt und dreht das Objekt zum angegebenen Ort
// 3D:
// - Der Punkt im Koordinatenursprung wird nach 'point' bewegt
// - Die Z-Achse ist die Pfeilrichtung, wird nach 'direction' gedreht,
// - Die X-Achse ist die Rotationsrichtung, wird um die Pfeilrichtung nach den Punkt 'orientation' gedreht
// 2D:
// - Der Punkt im Koordinatenursprung wird nach point bewegt
// - Die X-Achse ist die Pfeilrichtung, wird nach 'direction' gedreht,
module connect (point=[0,0,0], direction=[0,0,1], orientation=[1,0,0])
{
	dimension = len(point);
	//
	if (dimension)
	{
		// 3D
		base_vector = [1,0];
		up_to_z     = rotate_backwards_to_vector_points ( [orientation], direction);
		plane       = projection_points (up_to_z);
		angle_base  = rotation_vector (base_vector, plane[0]);
		//
		translate (point)
		rotate_to_vector (direction, angle_base)
		children();
	}
	else if (dimension)
	{
		// 2D
		translate (point)
		rotate_to_vector (direction, d=2)
		children();
	}
}
function connect (object, point=[0,0,0], direction=[0,0,1], orientation=[1,0,0]) =
	let (
		dimension = len(point) // TODO use this from the object
	)
	dimension==3 ?
	// 3D
	let(
		base_vector = [1,0],
		up_to_z     = rotate_backwards_to_vector_points ( [orientation], direction),
		plane       = projection_points (up_to_z),
		angle_base  = rotation_vector (base_vector, plane[0]),
		//
		a = rotate_to_vector (object, direction, angle_base),
		b = translate (a, point)
	)
		b
	:
	dimension==2 ?
	// 2D
	let(
		a = rotate_to_vector (object, direction),
		b = translate (a, point)
	)
		b
	:
	undef
;
function connect_points (list, point=[0,0,0], direction=[0,0,1], orientation=[1,0,0]) =
	let (
		dimension = len(point) // TODO use this from the object
	)
	dimension==3 ?
	// 3D
	let(
		base_vector = [1,0],
		up_to_z     = rotate_backwards_to_vector_points ( [orientation], direction),
		plane       = projection_points (up_to_z),
		angle_base  = rotation_vector (base_vector, plane[0]),
		//
		a = rotate_to_vector_points (list, direction, angle_base),
		b = translate_points (a, point)
	)
		b
	:
	dimension==2 ?
	// 2D
	let(
		a = rotate_to_vector_points (list, direction),
		b = translate_points (a, point)
	)
		b
	:
	undef
;

// Platziert Objekte nacheinander den angegebenen Punkten in der Liste
// Punkt 1 für Objekt 1,  Punkt 2 für Objekt 2, ...
module place (points)
{
	for (i=[0:1:min( len(points), $children-1)])
		translate (points[i])
		children(i);
}
// Platziert Objekte nacheinander entlang der angegebenen Richtung an den angegebenen Entfernungen
module place_line (direction, distances)
{
	Direction = unit_vector(
		(is_list(direction) && len(direction)>1) ?
			direction
		:	[0,0,1]
	);
	//
	if (distances!=undef && is_list(distances))
		// jedes Objekt der jeweiligen Position zuordnen
		for (i=[0:1:min( len(distances)-1, $children-1)])
			translate (distances[i]*Direction)
			children(i);
	else if (distances!=undef && is_num(distances))
		// alle Objekte an der einen Position
		translate (distances*Direction)
		children();
}
// Platziert Objekte entlang der entsprechenden Achse an den angegebenen Entfernungen
module place_x (distances)
{
	if (distances!=undef && is_list(distances))
		// jedes Objekt der jeweiligen Position zuordnen
		for (i=[0:1:min( len(distances)-1, $children-1)])
			translate_x (distances[i])
			children(i);
	else if (distances!=undef && is_num(distances))
		// alle Objekte an der einen Position
		translate_x (distances)
		children();
}
module place_y (distances)
{
	if (distances!=undef && is_list(distances))
		// jedes Objekt der jeweiligen Position zuordnen
		for (i=[0:1:min( len(distances)-1, $children-1)])
			translate_y (distances[i])
			children(i);
	else if (distances!=undef && is_num(distances))
		// alle Objekte an der einen Position
		translate_y (distances)
		children();
}
module place_z (distances)
{
	if (distances!=undef && is_list(distances))
		// jedes Objekt der jeweiligen Position zuordnen
		for (i=[0:1:min( len(distances)-1, $children-1)])
			translate_z (distances[i])
			children(i);
	else if (distances!=undef && is_num(distances))
		// alle Objekte an der einen Position
		translate_z (distances)
		children();
}

// Platziert und kopiert ein Objekt an den angegebenen Punkten in der Liste
module place_copy (points)
{
	for (p=points)
		translate (p)
		children();
}
// Platziert und kopiert ein Objekt entlang der angegebenen Richtung an den angegebenen Entfernungen
module place_copy_line (direction, distances)
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
// Platziert und kopiert ein Objekt entlang der entsprechenden Achse an den angegebenen Entfernungen
module place_copy_x (distances)
{
	for (l=distances)
		translate_x (l)
		children();
}
module place_copy_y (distances)
{
	for (l=distances)
		translate_y (l)
		children();
}
module place_copy_z (distances)
{
	for (l=distances)
		translate_z (l)
		children();
}
