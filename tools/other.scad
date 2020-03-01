// other.scad
//
// Enthält verschiedene Module, die ich im Internet gefunden habe.
// Die Quelle und die Lizenz ist mit angegeben und sollte berücksichtigt werden


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
			children(0);

			rotate([90,0,0]) 
			linear_extrude(height = height, center = true, convexity = convexity, twist = 0) 
			projection(cut=false) 
			rotate([-90,0,0]) 
			children(0);
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
			children(0);

			rotate([0,0,0]) 
			linear_extrude(height = height, center = true, convexity = convexity, twist = 0) 
			projection(cut=false) 
			rotate([0,0,0]) 
			children(0);
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
		rotate_extrude(convexity=convexity) translate([radius,0,0]) children(0);
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


// from Gael Lafond, https://www.thingiverse.com/thing:2200395
// License: CC0 1.0 Universal
//
// creates a helix with a 2D-polygon similar rotate_extrude
//
//   angle     = angle of helix in degrees - default: 360°
//   height    = height of helix - default: 0 like rotate_extrude
//   slices    = count of segments from helix per full rotation
//   convexity = 0 - only concave polygon
//               1 - can handle one convex polygon only (default)
//               2 - can maybe handle more then one convex polygon
//                   this will slice the 2D-polygon in little pieces and hope they are concave
//                   experimental with some problems
//               it's better to split it in concave helixes with the same parameter
//               and make the difference with it
module helix_extrude (angle=360, height=0, slices=30, convexity=1, scope=32, step=1)
{
	segment_count = ceil(angle/360 * slices);
	//
	union()
	{
		for (i = [0:segment_count-1])
			translate([0, 0, height/segment_count * i])
			rotate([0, 0, angle/segment_count * i])
			if (convexity>=2)
				render(convexity=convexity)
				helix_segment_slice(angle/segment_count, height/segment_count, scope,step)
				children();
			else
				render()
				helix_segment      (angle/segment_count, height/segment_count, convexity)
				children();
	}
}

module helix_segment_slice (angle, height, scope=32, step=1)
{
	scope_x = [-scope/2, scope/2]; step_x = step;
	scope_y = [-scope/2, scope/2]; step_y = step;
	//
	union()
	{
		for (x = [scope_x[0]:step_x:scope_x[1]], y = [scope_y[0]:step_y:scope_y[1]])
		helix_segment(angle, height, 1)
		intersection()
		{
			children();
			translate([x,y,0]) square([step_x+epsilon,step_y+epsilon]);
		}
	}
}

module helix_segment (angle, height, convexity=1)
{
	difference()
	{
		hull()
		{
			helix_object_intern() children();
			translate([0,0,height]) rotate([0,0,angle])
			helix_object_intern() children();
		}
		if (convexity>=1)
		hull()
		{
			helix_object_diff_intern() children();
			translate([0,0,height]) rotate([0,0,angle])
			helix_object_diff_intern() children();
		}
	}
}

module helix_object_intern ()
{
	rotate([90,0,0]) linear_extrude(epsilon) children();
}
module helix_object_diff_intern ()
{
	difference()
	{
		rotate([90,0,0]) hull() translate([0,0,-epsilon ]) linear_extrude(epsilon2) children();
		rotate([90,0,0])        translate([0,0,-epsilon2]) linear_extrude(epsilon4) children();
	}
}
