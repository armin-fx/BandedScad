// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Objekte, um Punkte und Linien anzeigen zu lassen
//

use <banded/operator_edit.scad>
use <banded/draft_color.scad>


// - In der Konsole anzeigen

module echo_line (length=50, char="-")
{
	function str_line (length, char, string="") =
		length<=0 ? string :
		str_line (length-1, char, str (string, char))
	;
	echo (str_line (length, char));
}

module echo_thin_line (length=50) { echo_line (length/2, " -"); }
module echo_bar       (length=50) { echo_line (length  , "=" ); }
module echo_wall      (length=50) { echo_line (length  , "#" ); }

module echo_list (list, txt="", pre="\t")
{
	echo( echo_list_helper_intern (list, txt, pre) );
}
function echo_list_helper_intern (list, txt="", pre="\t", i=0) =
	i>=len(list) ? txt :
	echo_list_helper_intern (list, str (txt ,"\n",pre, list[i]), pre, i+1 )
;


// - Linien und Punkte sichtbar machen:

module show_point (p, c, d=0.2)
{
	if (p!=undef)
		color (get_debug_color(c))
		%
		translate(p)
		sphere(d=d, $fn=6);
}

module show_points (p_list, c, d=0.2)
{
	if (p_list!=undef)
	{
		size = len(p_list);
		for (i=[0:1:size-1])
		{
			show_point (p_list[i], get_debug_color(c,i,size), d);
		}
	}
}
module show_points_colored (p_list, d=0.2)
{
	show_points (p_list, true, d=0.2);
}

module show_line (l, c, direction=false, d=0.1)
{
	if (l!=undef)
	{
		if (direction!=true)
		{
			color (get_debug_color(c))
			%
			extrude_line (l, Z) circle(d=d, $fn=6);
		}
		else
		{
			L = [for (i=[0,1]) fill_missing_list (l[i], [0,0,0]) ];
			length = norm(L[1]-L[0]);
			arrow_length = length<5*d ? length : 5*d;
			arrow_ratio  = 3 / 5;
			
			if (length>arrow_length)
			{
				color (get_debug_color(c))
				%
				translate (L[0])
				rotate_to_vector (L[1]-L[0])
				cylinder (h=length-arrow_length, d=d, $fn=6);
			}
			
			color (get_debug_color(c))
			%
			translate (L[1])
			rotate_to_vector (L[0]-L[1])
			cylinder(h=arrow_length, d1=0, d2=arrow_length*arrow_ratio, $fn=6);
		}
	}
}

module show_lines (l_list, c, direction=false, d=0.1)
{
	if (l_list!=undef)
	{
		size = len(l_list);
		for (i=[0:1:size-1])
		{
			show_line (l_list[i], get_debug_color(c,i,size), direction, d);
		}
	}
}
module show_lines_colored (l_list, direction=false, d=0.1)
{
	show_lines (l_list, true, direction, d);
}

module show_vector (v, p, c, direction=true, d=0.1)
{
	if (v!=undef)
	{
		P = p!=undef ? p : [for (i=[0:1:len(v)-1]) 0];
	
		show_line ([P, P+v], get_debug_color(c), direction, d);
	}
}

module show_trace (p_list, c, closed=false, direction=false, d=0.1, p_factor=1.5)
{
	if (p_list!=undef)
	{
		size = len(p_list);
		for (i=[0:1:size-1+(closed==true ? 0 : -1) ])
		{
			p1=p_list[ i        ];
			p2=p_list[(i+1)%size];
			
			if (p1!=p2)
				{ show_line ([p1, p2], get_debug_color(c,i,size), direction, d); }
			else
				{ show_point (p1, get_debug_color(c,i,size), d*p_factor); }
		}
	}
}
module show_trace_colored (p_list, closed=false, direction=false, d=0.1, p_factor=1.5)
{
	show_trace (p_list, true, closed, direction, d, p_factor);
}

module show_traces (p_lists, c, closed=false, direction=false, d=0.1, p_factor=1.5)
{
	if (p_lists!=undef)
	{
		size = len(p_lists);
		for (i=[0:1:size-1])
		{
			show_trace (p_lists[i], get_debug_color(c,i,size), closed, direction, d, p_factor);
		}
	}
}
module show_traces_colored (p_lists, closed=false, direction=false, d=0.1, p_factor=1.5)
{
	show_traces (p_lists, true, closed, direction, d, p_factor);
}

module show_label (txt, h=2.5, p=[0,0,0], a=$vpr, valign="baseline", halign="left")
{
    color     ("black")
	%
	translate (p)
	rotate    (a)
	linear_extrude(0.01)
	scale     (h/10)
	text      (txt, valign=valign, halign=halign);
}

function get_debug_color (c, i, size, default="orange") =
	(c!=true || i==undef) ?
		c==undef || c==false ?
			default
		:	c
	:		color_hsv_to_rgb ([i/size*360,1,1])
;


// - Teile von Objekte testen:

// Schneidet eine Scheibe aus einem Objekt, geeignet um testweise versteckte Details eines Objekts ansehen zu können
module object_slice (axis=[0,1,0], position=0, thickness=1, limit=1000)
{
	trans_side = (thickness>=0) ? 0 : -thickness;
	intersection()
	{
		children();
		//
		if      (axis[0]!=0) translate([position+trans_side,-limit/2,-limit/2]) cube([abs(thickness),limit,limit]);
		else if (axis[1]!=0) translate([-limit/2,position+trans_side,-limit/2]) cube([limit,abs(thickness),limit]);
		else if (axis[2]!=0) translate([-limit/2,-limit/2,position+trans_side]) cube([limit,limit,abs(thickness)]);
	}
}

// create a small pane in X-Y-plane of an object at given height (Z-axis)
module object_pane (position=0, thickness=epsilon*2, limit=1000)
{
	pane_size =
		is_num(limit) ? [limit, limit] :
		is_list(limit) && len(limit)==2 ? limit :
		[1000, 1000]
	;
	
	intersection()
	{
		children();
		//
		translate([-pane_size[0]/2,-pane_size[1]/2, -thickness/2 + position])
			cube([pane_size[0],pane_size[1],thickness]);
	}
}
