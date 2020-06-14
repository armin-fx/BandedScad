// operator_position.scad
//
// Enthält einige zusätzliche Operatoren zum Platzieren von Objekten


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

// Platziert ein Objekt an den angegebenen Punkten
module place (points)
{
	for (p=points)
		translate (p)
		children();
}
