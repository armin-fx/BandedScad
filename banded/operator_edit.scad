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

combine_type_undef = -1;
combine_type_main  = 0;
combine_type_add   = 1;
combine_type_cut       = 2;
combine_type_cut_self  = 3;
combine_type_cut_other = 4;
combine_type_cut_all   = 5;
combine_type_limit = 6;

$combine_type=combine_type_undef;

// Setzt ein Objekt mit anderen Objekten zusammen
//
module combine (limit=false, type=combine_type_undef, select=undef)
{
	list =
		select==undef  ? [0:1:$children-1] :
		is_num(select) ? let (s=get_index($children,select))    (s<$children && s>=0) ? [s] : [] :
		[ for (e=select) let (s=get_index($children,e     )) if (s<$children && s>=0)    s  ]
	;
	
	// select one part type for testing
	if (type!=combine_type_undef)
	{
		union() {
			$combine_type = type;
			children(list);
		}
	}
	// combine all parts
	else union()
	{
		difference()
		{
			intersection()
			{
				// main part
				union() {
					$combine_type = combine_type_main;
					children(list);
				}
				// limit part
				if (limit==true) union() {
					$combine_type = combine_type_limit;
					children(list);
				}
			}
			// cut part
			union() {
				$combine_type = combine_type_cut;
				children(list);
			}
		}
		// add part
		for (i=list)
		{
			difference ()
			{
				union() {
					$combine_type = combine_type_add;
					children(i);
				}
				// handle self cut part
				union() {
					$combine_type = combine_type_cut_self;
					children(i);
				}
				union() {
					other = [ for (e=list) if (e!=i) e ];
					$combine_type = combine_type_cut_other;
					children(other);
				}
				union() {
					$combine_type = combine_type_cut_all;
					children(list);
				}
			}
		}
	}
}

function is_part_main () =
	$combine_type==combine_type_main
;
//
function is_part_add () =
	$combine_type==combine_type_add
;
//
function is_part_cut  (self=false, other=false) =
		$combine_type==combine_type_cut
		|| (self==true  && other==false && $combine_type==combine_type_cut_self)
		|| (self==false && other==true  && $combine_type==combine_type_cut_other)
		|| (self==true  && other==true  && $combine_type==combine_type_cut_all)
;
function is_part_cut_self  (other=false) = is_part_cut (self=true, other=other);
function is_part_cut_other (self =false) = is_part_cut (self=self, other=true);
function is_part_cut_all   ()            = is_part_cut (self=true, other=true);
function is_part_cut_type () =
		   $combine_type==combine_type_cut
		|| $combine_type==combine_type_cut_self
		|| $combine_type==combine_type_cut_other
		|| $combine_type==combine_type_cut_all
;
//
function is_part_limit () =
	$combine_type==combine_type_limit
;


module part_main ()
{
	always = $parent_modules==1 || $combine_type==combine_type_undef;
	if (always || is_part_main() )
	{
		children();
	}
}

module part_add ()
{
	always = $parent_modules==1 || $combine_type==combine_type_undef;
	if (always || is_part_add() )
	{
		children();
	}
}

module part_cut (self=false, other=false)
{
	always = $parent_modules==1;
	if (always || is_part_cut(self, other) )
	{
		children();
	}
}
module part_cut_self  (other =false) { part_cut (self=true, other=other) children(); }
module part_cut_other (self=false)   { part_cut (self=self, other=true ) children(); }
module part_cut_all   ()             { part_cut (self=true, other=true ) children(); }

module part_limit ()
{
	always = $parent_modules==1;
	if (always || is_part_limit() )
	{
		children();
	}
}

module part_type (type)
{
	if      (type==combine_type_main)      part_main()      children();
	else if (type==combine_type_add)       part_add()       children();
	else if (type==combine_type_cut)       part_cut()       children();
	else if (type==combine_type_cut_self)  part_cut_self()  children();
	else if (type==combine_type_cut_other) part_cut_other() children();
	else if (type==combine_type_cut_all)   part_cut_all()   children();
	else if (type==combine_type_limit)     part_limit()     children();
}

// Setzt ein Objekt mit anderen Objekten zusammen mit fester Reihenfolge
//
// Reihenfolge: Hauptobjekt(); zugefuegtes_Objekt(); abzuschneidendes_Objekt(); gemeinsames_Objekt();
//
module combine_fixed ()
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

// Wählt das i' te Objekt aus
module select_object (i)
{
	if (i!=undef && is_num(i))
	    if (i>=0) children (i);
		else      children ($children+i);
	else if (i!=undef && is_list(i))
		for (j=i) children (j);
	else          children ();
}


// - Objekte verändern:

// Experimentell,
// funktioniert bis 8 Objekte, manchmal treten Probleme auf
module xor (d=3, skirt=epsilon)
{
	if ($children==1) children();
	if ($children==2)
		xor_2 (d, skirt) { children(0); children(1); };
	if ($children==3)
		xor_2 (d, skirt) {
			xor_2 (d, skirt) { children(0); children(1); };
			children(2);
		};
	if ($children==4)
		xor_2 (d, skirt) {
			xor_2 (d, skirt) { children(0); children(1); };
			xor_2 (d, skirt) { children(2); children(3); };
		};
	if ($children==5)
		xor_2 (d, skirt) {
			xor_2 (d, skirt) { children(0); children(1); };
			xor   (d, skirt) { children(2); children(3); children(4); };
		};
	if ($children==6)
		xor_2 (d, skirt) {
			xor   (d, skirt) { children(0); children(1); children(2); children(3); };
			xor_2 (d, skirt) { children(4); children(5); };
		};
	if ($children==7)
		xor_2 (d, skirt) {
			xor (d, skirt) { children(0); children(1); children(2); children(3); };
			xor (d, skirt) { children(4); children(5); children(6); };
		};
	if ($children==8)
		xor_2 (d, skirt) {
			xor (d, skirt) { children(0); children(1); children(2); children(3); };
			xor (d, skirt) { children(4); children(5); children(6); children(7); };
		};
}
module xor_2 (d=3, skirt=epsilon)
{
	difference()
	{
		children();
		//
		if ($children>1)
		minkowski()
		{
			intersection_for (i = [0:1:$children-1])
			children(i);
			if      (d==3) sphere(skirt, $fn=8);
			else if (d==2) circle(skirt, $fn=8);
		}
	}
}

module minkowski_difference (d=3, convexity)
{
	if ($children==1) children();
	if ($children>1)
	difference()
	{
		bounding_box(d=d) children(0);
		//
		minkowski(convexity=convexity)
		{
			difference()
			{
				minkowski()
				{
					bounding_box(d=d) children(0);
					if (d==3) cube  (center=true);
					if (d==2) square(center=true);
				}
				//
				children(0);
			}
			for (i=[1:1:$children-1]) children(i);
		}
	}
}

// Experimentell,
// manchmal treten Probleme auf
module hull_difference (d=3, skirt=epsilon)
{
	if ($children>0)
	hull()
	{
		for (i=[0:1:$children-1])
		difference()
		{
			hull()
				children(i);
			//
			minkowski()
			{
				children(i);
				if      (d==3) sphere(skirt, $fn=8);
				else if (d==2) circle(skirt, $fn=8);
			}
		}
	}
}

// Experimentell,
// manchmal treten Probleme auf
module chain (d=3, skirt=epsilon)
{
	if ($children>1)
	render()
	for (i=[0:1:$children-2])
	difference()
	{
		hull()
			{ children(i); children(i+1); }
		//
		minkowski()
		{
			hull_difference (skirt=skirt)
				{ children(i); children(i+1); }
			if      (d==3) sphere(skirt, $fn=8);
			else if (d==2) circle(skirt, $fn=8);
		}
	}
}

module bounding_box (d=3, height=1000)
{
	if (d==3) bounding_box_3d_intern (height=height) hull() children();
	if (d==2) bounding_box_2d_intern (height=height) hull() children();
}
module bounding_box_2d_intern (height=1000)
{
	render()
	intersection()
	{
		projection(cut=false) rotate([0,90,0]) linear_extrude(height=height, center=true) children();
		projection(cut=false) rotate([90,0,0]) linear_extrude(height=height, center=true) children();
	}
}
module bounding_box_3d_intern (height=1000)
{
	module projection_z (side, rotation=[0,0,0])
	{
			projection (cut=false)
			rotate (rotation)
			rotate (side)
			linear_extrude (height=height, center=true)
			projection (cut=false)
			rotate (-side)
			children();
	}
	
	render()
	intersection()
	{
		linear_extrude (height=height, center=true)
		intersection()
		{
			projection_z (side=[0,90,0]) children();
			projection_z (side=[90,0,0]) children();
		}
		
		rotate ([90,0,0])
		linear_extrude (height=height, center=true)
		intersection()
		{
			projection_z (side=[0,90,0], rotation=[-90,0,0]) children();
			projection_z (side=[0,0,0] , rotation=[-90,0,0]) children();
		}
	}
}

// Objekte aufspalten:
//
module split_inner (gap=0, balance=0)
{
	d = gap * (1-balance);
	n = get_slices_circle_current_x (d/2, $fn_min=12);
	//
	intersection()
	{
		children([1:1:$children-1]);
		//
		minkowski_difference(convexity=4)
		{
			children(0);
			//
			if (d>0)
		//	sphere (d=d, $fn=12); /*
			rotate_extrude ($fn=n)
			difference()
			{
				circle(d=d);
				translate(-[d+extra,d/2+extra])
				square([d+extra,d+2*extra]);
			} //*/
		}
	}
}
//
module split_outer (gap=0, balance=0)
{
	d = gap * (balance+1);
	n = get_slices_circle_current_x (d/2, $fn_min=12);
	//
	difference()
	{
		children([1:1:$children-1]);
		//
		minkowski(convexity=4)
		{
			children(0);
			//
			if (d>0)
		//	sphere (d=d, $fn=12); /*
			rotate_extrude ($fn=n)
			difference()
			{
				circle(d=d);
				translate(-[d+extra,d/2+extra])
				square([d+extra,d+2*extra]);
			} //*/
		}
	}
}
//
module split_both (gap=0, balance=0)
{
	split_inner(gap, balance) { children(0); children([1:1:$children-1]); }
	split_outer(gap, balance) { children(0); children([1:1:$children-1]); }
}
//
/*
// TODO
module split_gap (gap=0, balance=0)
{
	difference()
	{
		children(0);
		split_outer(gap, balance) { children(0); children([1:1:$children-1]); }
		split_inner(gap, balance) { children(0); children([1:1:$children-1]); }
	}
}
//*/


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
		get_trace_connect(extract(trace, range=[0,-2]))
	:	concat ( [trace[len(trace)-1]], trace, [trace[0],trace[1]] )
;
range_connect=[1,-2];
//
function get_angle_between (ratio, a, b) =
	(a+b + ((abs(a-b)<180)?0:360) ) * ratio
;

//
module plain_trace_extrude (trace, range=[0,-1], closed=false, convexity, limit=1000)
{
	if (closed!=true)
		plain_trace_extrude_open   (trace, range, convexity, limit) children();
	else
		plain_trace_extrude_closed (trace, range, convexity, limit) children();
}
module plain_trace_extrude_open (trace, range=[0,-1], convexity, limit=1000)
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
module plain_trace_extrude_closed (trace, range=[0,-1], convexity, limit=1000)
{
	if (is_list(trace) && len(trace)>1)
	plain_trace_extrude_open (
		trace=get_trace_connect(extract(trace, range=range))
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
//   orientation = if true, orientation of Y-axis from the 2D-polygon is set along the surface of the cone.
//                 false = default, orientation of Y-axis from the 2D-polygon is set to Z-axis
//   slices    = count of segments from helix per full rotation
//   convexity = 0 - only concave polygon (default)
//               1 - can handle one convex polygon only
//               2 - can maybe handle more then one convex polygon
//                   this will slice the 2D-polygon in little pieces and hope they are concave
//                   experimental with some problems
//               it's better to split it in concave helixes with the same parameter
//               and make the difference with it
module helix_extrude (angle, rotations, pitch, height, r, opposite, orientation, slices=32, convexity=0, scope, step)
{
	R  = parameter_cylinder_r_basic (r, r[0], r[1], preset=[0,0]);
	rp = parameter_helix_to_rp (
		is_num(angle) ? angle/360 : rotations,
		pitch,
		height
	);
	Rotations = abs(rp[0]);
	Angle     = Rotations * 360;
	Pitch     = rp[1];
	Height    = Rotations * Pitch;
	Opposite  = xor( (is_bool(opposite) ? opposite : false), rp[0]<0 );
	R_max  = max(R)==0 ? 9 : max(R);
	m = orientation==true ?
		  matrix_rotate (-90, d=2, short=true)
		* matrix_rotate_to_vector ([-(R[0]-R[1]),Height], d=2, short=true)
		: identity_matrix (2);
	//
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
				{
					if (orientation==true) multmatrix(m) children();
					else                   children();
				}
			else
				helix_segment      (i==segment_last ? segment_angle : segment_angle_extra,
					segment_height, segment_radius, Opposite, convexity=convexity)
				{
					if (orientation==true) multmatrix(m) children();
					else                   children();
				}
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
