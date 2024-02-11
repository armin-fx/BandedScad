// Copyright (c) 2020 Armin Frenzel
// License: various
//
// Enthält verschiedene Module, die ich im Internet gefunden habe.
// Die Quelle und die Lizenz ist mit angegeben und sollte berücksichtigt werden


// from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Commented_Example_Projects
//
// license: Creative Commons Attribution-ShareAlike License
//          https://creativecommons.org/licenses/by-sa/4.0/
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

