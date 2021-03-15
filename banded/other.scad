// Copyright (c) 2020 Armin Frenzel
// License: various
//
// Enthält verschiedene Module, die ich im Internet gefunden habe.
// Die Quelle und die Lizenz ist mit angegeben und sollte berücksichtigt werden

include <banded/constants.scad>
//
use <banded/extend.scad>
use <banded/helper_native.scad>
use <banded/operator_transform.scad>


// from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Commented_Example_Projects
//
// Rather kludgy module for determining bounding box from intersecting projections
module bounding_box (convexity=5, height=1000)
{
	intersection()
	{
		translate([0,0,0])
		linear_extrude(height = height, center = true, convexity = convexity, twist = 0) 
		projection(cut=false) intersection()
		{
			rotate([0,90,0]) 
			linear_extrude(height = height, center = true, convexity = convexity, twist = 0) 
			projection(cut=false) 
			rotate([0,-90,0]) 
			children();

			rotate([90,0,0]) 
			linear_extrude(height = height, center = true, convexity = convexity, twist = 0) 
			projection(cut=false) 
			rotate([-90,0,0]) 
			children();
		}
		rotate([90,0,0]) 
		linear_extrude(height = height, center = true, convexity = convexity, twist = 0) 
		projection(cut=false) 
		rotate([-90,0,0])
		intersection()
		{
			rotate([0,90,0]) 
			linear_extrude(height = height, center = true, convexity = convexity, twist = 0) 
			projection(cut=false) 
			rotate([0,-90,0]) 
			children();

			rotate([0,0,0]) 
			linear_extrude(height = height, center = true, convexity = convexity, twist = 0) 
			projection(cut=false) 
			rotate([0,0,0]) 
			children();
		}
	}
}


// from CarryTheWhat, http://www.thingiverse.com/thing:34027
// License: GNU - LGPL
//
// Use (same as rotate_extrude):
// rotate_extrude_partial(angle, radius, convexity) circle(5);
//
// This will extrude the circle for angle degrees about the origin at a distance of radius
//
module rotate_extrude_partial (angle, radius, convexity=10)
{
	intersection ()
	{
		rotate_extrude(convexity=convexity) translate([radius,0,0]) children();
		pie_slice(radius*2, angle, angle/5);
	}
}

module pie_slice (radius, angle, step)
{
	for(theta = [0:step:angle-step])
	{
		linear_extrude(height = radius*2, center=true)
		polygon(points = [
			[0,0],
			[radius * cos(theta+step) ,radius * sin(theta+step)],
			[radius * cos(theta),      radius * sin(theta)]
			]);
	}
}


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
//               r1 = bottom radius, r2 = top Radius
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
		slices==undef ? get_fn_circle_current  (R_max, Angle) :
		slices=="x"   ? get_fn_circle_current_x(R_max, Angle) :
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
			rotate_z_list([[1000,0]], angle * (opposite==true ? -1 : 1)) [0]
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
