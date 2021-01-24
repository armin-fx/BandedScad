// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Operatoren zum Bearbeiten und Testen von Objekten
//
// Aufbau: modul() {Objekt(); <Objekt2; ...>}

include <banded/constants.scad>
//
use <banded/helper_native.scad>
use <banded/math_vector.scad>
use <banded/draft_transform_common.scad>
use <banded/draft_transform_basic.scad>
use <banded/operator_transform.scad>

// Setzt ein Objekt mit anderen Objekten zusammen
//
// Reihenfolge: Hauptobjekt(); zugefuegtes_Objekt(); abzuschneidendes_Objekt(); gemeinsames_Objekt();
//
module combine ()
{
	if ($children==0);
	if ($children==1)
		children(0);
	if ($children==2)
		union()
		{
			children(0);
			children(1);
		}
	if ($children==3)
		union()
		{
			difference()
			{
					children(0);
					children(2);
			}
			children(1);
		}
	if ($children==4)
		intersection()
		{
			union()
			{
				difference()
				{
					children(0);
					children(2);
				}
				children(1);
			}
			children(3);
		}
}

// Experimentell,
// funktioniert mit 2 Objekte, bei weitere treten Probleme auf
module xor()
{
	difference()
	{
		children();
		
		minkowski()
		{
			intersection_for (i = [0 : $children-1])
				children(i);
			sphere(0.0000000001);
		}
	}
}

// Schneidet eine Scheibe aus einem Objekt, geeignet um testweise versteckte Details eines Objekts ansehen zu können
module object_slice (axis=[0,1,0], position=0, thickness=1, height=1000)
{
	trans_side = (thickness>=0) ? 0 : -thickness;
	intersection()
	{
		children();
		//
		if      (axis[0]!=0) translate([position+trans_side,-height/2,-height/2]) cube([abs(thickness),height,height]);
		else if (axis[1]!=0) translate([-height/2,position+trans_side,-height/2]) cube([height,abs(thickness),height]);
		else if (axis[2]!=0) translate([-height/2,-height/2,position+trans_side]) cube([height,height,abs(thickness)]);
	}
}

// create a small pane of an object at given height (Z-axis)
module object_pane (pos=0, thickness=epsilon*2, size=[1000,1000])
{
	intersection()
	{
		children();
		//
		translate([-size[0]/2,-size[1]/2, -thickness/2 + pos])
			cube([size[0],size[1],thickness]);
	}
}

// extrudiert und dreht das 2D-Objekt die Linie 'line' entlang
// Die X-Achse ist die Rotationsrichtung, wird um die Pfeilrichtung nach den Punkt 'rotational' gedreht
module extrude_line (line, rotational=[1,0,0], convexity, extra_h=0)
{
	base_vector = [1,0];
	origin      = line[0];
	line_vector = line[1] - line[0];
	up_to_z     = rotate_backwards_to_vector_list ( [rotational], line_vector);
	plane       = projection_list (up_to_z);
	angle_base  = rotation_vector (base_vector, plane[0]);
	//
	translate (origin)
	rotate_to_vector (line_vector, angle_base)
	translate_z (-extra_h)
	linear_extrude (height=norm(line_vector)+extra_h*2, convexity=convexity)
	children();
}


function get_trace_connect(trace) =
	trace[0]==trace[len(trace)-1] ?
		get_trace_connect(extract_list(trace, range=[0,-2]))
	:	concat ( [trace[len(trace)-1]], trace, [trace[0],trace[1]] )
;
range_connect=[1,-2];
//
function get_angle_between (ratio, a, b) =
	(a+b + ((abs(a-b)<180)?0:360) ) * ratio
;

//
module plain_trace_extrude (trace, range=[0,-1], convexity, lenght=1000)
{
	begin = get_position(trace, range[0]);
	last  = get_position(trace, range[1]) - 1;
	overlap=epsilon;
	//
	if (is_list(trace) && len(trace)>1)
	for (i=[begin:last])
	{
		difference()
		{
			translate(trace[i])
			rotate_z(rotation_vector([0,1], trace[i+1]-trace[i]))
			rotate_x(90) linear_extrude(height=lenght, center=true, convexity=convexity) children();
			//
			translate(trace[i])
			rotate_z(
				(i==0) ?
					rotation_vector([0,-1], trace[i+1]-trace[i])
				:	get_angle_between(0.5, rotation_vector([0,-1], trace[i+1]-trace[i]), rotation_vector([0,-1], trace[i]-trace[i-1]))
			)
			translate([-lenght/2,overlap,-lenght/2]) cube([lenght,lenght,lenght]);
			//
			translate(trace[i+1])
			rotate_z(
				(i>=len(trace)-2) ?
					rotation_vector([0,-1], trace[i+1]-trace[i])
				:	get_angle_between(0.5, rotation_vector([0,-1], trace[i+1]-trace[i]), rotation_vector([0,-1], trace[i+2]-trace[i+1]))
			)
			translate([-lenght/2,-lenght-overlap,-lenght/2]) cube([lenght,lenght,lenght]);
		}
	}
}
module plain_trace_connect_extrude (trace, range=[0,-1], convexity, lenght=1000)
{
	if (is_list(trace) && len(trace)>1)
	plain_trace_extrude (
		trace=get_trace_connect(extract_list(trace, range=range))
		,range=range_connect, convexity=convexity, lenght=lenght
	) children();
}

/*
module trace_extrude (trace, rotation, convexity, lenght=1000)
{}
*/
