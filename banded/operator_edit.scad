// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Operatoren zum Bearbeiten und Testen von Objekten
//
// Aufbau: modul() {Objekt(); <Objekt2; ...>}

include <banded/constants.scad>
//
use <banded/extend.scad>
use <banded/helper.scad>
use <banded/math_vector.scad>
use <banded/draft_transform_common.scad>
use <banded/draft_transform_basic.scad>
use <banded/operator_transform.scad>


// - Objekte kombinieren:

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

// - 2D zu 3D extrudieren:

// extrudiert und dreht das 2D-Objekt die Linie 'line' entlang
// Die X-Achse ist die Rotationsrichtung, wird um die Pfeilrichtung nach den Punkt 'rotational' gedreht
module extrude_line (line, rotational=[1,0,0], convexity, extra_h=0)
{
	base_vector = [1,0];
	origin      = fill_missing_list (line[0]           , [0,0,0]);
	line_vector = fill_missing_list (line[1] - line[0] , [0,0,0]);
	up_to_z     = rotate_backwards_to_vector_points ( [rotational], line_vector);
	plane       = projection_points (up_to_z);
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
module plain_trace_extrude (trace, range=[0,-1], convexity, limit=1000)
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
			rotate_x(90) linear_extrude(height=limit, center=true, convexity=convexity) children();
			//
			translate(trace[i])
			rotate_z(
				(i==0) ?
					rotation_vector([0,-1], trace[i+1]-trace[i])
				:	get_angle_between(0.5, rotation_vector([0,-1], trace[i+1]-trace[i]), rotation_vector([0,-1], trace[i]-trace[i-1]))
			)
			translate([-limit/2,overlap,-limit/2]) cube([limit,limit,limit]);
			//
			translate(trace[i+1])
			rotate_z(
				(i>=len(trace)-2) ?
					rotation_vector([0,-1], trace[i+1]-trace[i])
				:	get_angle_between(0.5, rotation_vector([0,-1], trace[i+1]-trace[i]), rotation_vector([0,-1], trace[i+2]-trace[i+1]))
			)
			translate([-limit/2,-limit-overlap,-limit/2]) cube([limit,limit,limit]);
		}
	}
}
module plain_trace_connect_extrude (trace, range=[0,-1], convexity, limit=1000)
{
	if (is_list(trace) && len(trace)>1)
	plain_trace_extrude (
		trace=get_trace_connect(extract_list(trace, range=range))
		,range=range_connect, convexity=convexity, limit=limit
	) children();
}

/*
module trace_extrude (trace, rotation, convexity, limit=1000)
{}
*/

// modified from Gael Lafond, https://www.thingiverse.com/thing:2200395
// License: CC0 1.0 Universal
//
// creates a helix with a 2D-polygon similar rotate_extrude
//
//   angle     = angle of helix in degrees - default: 360°
//   rotations = rotations of helix, can be used instead angle
//   height    = height of helix - default: 0 like rotate_extrude
//   pitch     = rise per rotation
//   r         = radius as number or [r1, r2]
//               r1 = bottom radius, r2 = top radius
//
//   opposite  = if true reverse rotation of helix, false = standard
//   slices    = count of segments from helix per full rotation
//   convexity = 0 - only concave polygon (default)
//               1 - can handle one convex polygon only
//               2 - can maybe handle more then one convex polygon
//                   this will slice the 2D-polygon in little pieces and hope they are concave
//                   experimental with some problems
//               it's better to split it in concave helixes with the same parameter
//               and make the difference with it
module helix_extrude (angle, rotations, pitch, height, r, opposite, slices=32, convexity=0, scope, step)
{
	R  = parameter_cylinder_r_basic (r, r[0], r[1], preset=[0,0]);
	rp = parameter_helix_to_rp (
		is_num(angle) ? angle/360 : rotations,
		pitch,
		height
	);
	Rotations = abs(rp[0]);
	Angle     = abs(rp[0] * 360);
	Pitch     = rp[1];
	Height    = Rotations * Pitch;
	Opposite  = xor( (is_bool(opposite) ? opposite : false), rp[0]<0 );
	R_max  = max(R)==0 ? 9 : max(R);
	segment_count =
		slices==undef ? get_slices_circle_current  (R_max, Angle) :
		slices=="x"   ? get_slices_circle_current_x(R_max, Angle) :
		max(2, ceil(slices * Rotations))
	;
	//
	union()
	{
		segment_height = Height/segment_count;
		segment_angle  = Angle /segment_count;
		segment_angle_extra = segment_angle + min(epsilon, segment_angle/4);
		segment_last = segment_count-1;
		//
		for (i = [0:1:segment_last])
		{
			segment_radius = [
				 bezier_1( (i  )/(segment_count), R )
				,bezier_1( (i+1)/(segment_count), R )
			];
			//
			translate_z(segment_height * i)
			rotate_z   (segment_angle * i * (Opposite==true ? -1 : 1))
			render(convexity=2+2*convexity)
			if (convexity>=2)
				helix_segment_slice(i==segment_last ? segment_angle : segment_angle_extra,
					segment_height, segment_radius, Opposite, scope,step)
				children();
			else
				helix_segment      (i==segment_last ? segment_angle : segment_angle_extra,
					segment_height, segment_radius, Opposite, convexity=convexity)
				children();
		}
	}
}

module helix_segment_slice (angle, height, radius, opposite=false, scope, step)
{
	Scope = is_num(scope) ? scope : 128;
	Step  = is_num(step)  ? step  :   4;
	scope_x = [-Scope/2, Scope/2]; step_x = Step;
	scope_y = [-Scope/2, Scope/2]; step_y = Step;
	//
	union()
	{
		for (x = [scope_x[0]:step_x:scope_x[1]], y = [scope_y[0]:step_y:scope_y[1]])
			helix_segment(angle, height, radius, opposite, 1)
			intersection()
			{
				children();
				translate([x,y]) square([step_x,step_y]);
			}
	}
}

module helix_segment (angle, height, radius, opposite=false, convexity=0)
{
	Radius =
		is_list(radius) ?
			is_num(radius[0]) ?
				is_num(radius[1]) ? radius
				:[radius[0],radius[0]]
			:[0,0]
		:is_num(radius) ? [radius,radius]
		:[0,0]
	;
	intersection()
	{
		difference()
		{
			hull()
			{
				helix_object_intern( opposite) translate_x(Radius[0]) children();
				translate_z(height) rotate_z(angle * (opposite==true ? -1 : 1))
				helix_object_intern(!opposite) translate_x(Radius[1]) children();
			}
			if (convexity>=1)
			hull()
			{
				helix_object_diff_intern( opposite) translate_x(Radius[0]) children();
				translate_z(height) rotate_z(angle * (opposite==true ? -1 : 1))
				helix_object_diff_intern(!opposite) translate_x(Radius[1]) children();
			}
		}
		linear_extrude(height=1000, center=true, convexity=2)
		polygon([
			[0,0],
			[1000,0],
			rotate_z_points([[1000,0]], angle * (opposite==true ? -1 : 1)) [0]
		]);
	}
}

module helix_object_intern (opposite)
{
	rotate_x(90)
	translate_z( (is_bool(opposite) && opposite==false) ? 0 : -epsilon)
	linear_extrude( is_bool(opposite) ? epsilon : epsilon*2) children();
}
module helix_object_diff_intern (opposite)
{
	minkowski()
	{
		sphere(d=epsilon,$fn=5);
		//
		rotate_x(90)
		translate_z( (is_bool(opposite) && opposite==false) ? 0 : -epsilon)
		difference()
		{
			hull()              linear_extrude( (is_bool(opposite) ? epsilon : epsilon*2)          ) children();
			translate_z(-extra) linear_extrude( (is_bool(opposite) ? epsilon : epsilon*2) + extra*2) children();
		}
	}
}
