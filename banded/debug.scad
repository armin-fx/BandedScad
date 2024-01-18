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
	echo (echo_line_intern (length, char));
}
function echo_line (length=50, char="-") =
	str( echo_line_intern (length, char), "\n" )
;
function echo_line_intern (length=50, char="-", string="") =
	length<=0 ? string :
	echo_line_intern (length-1, char, str (string, char))
;

module   echo_thin_line (length=50) { echo_line (length/2, " -"); }
function echo_thin_line (length=50) = echo_line (length/2, " -");
module   echo_bar       (length=50) { echo_line (length  , "=" ); }
function echo_bar       (length=50) = echo_line (length  , "=" );
module   echo_wall      (length=50) { echo_line (length  , "#" ); }
function echo_wall      (length=50) = echo_line (length  , "#" );

module echo_list (list, txt="", pre="\t")
{
	echo( echo_list_intern (list, txt, pre) );
}
function echo_list (list, txt="", pre="\t") =
	str( echo_list_intern (list, txt, pre), "\n" )
;
function echo_list_intern (list, txt="", pre="\t", i=0) =
	i>=len(list) ? txt :
	echo_list_intern (list, str (txt ,"\n",pre, list[i]), pre, i+1 )
;

// function returns value and echo a message if version of OpenSCAD is 2019.05 or greater
function do_echo (value, message) =
	version_num()<20190500 ? value
	: echo(message) + value
;


// - Linien und Punkte sichtbar machen:

module show_point (p, c, d=0.2, auto=0)
{
	if (p!=undef)
		color (get_debug_color(c))
		%
		translate(p)
		sphere(d=get_debug_width (d,auto), $fn=6);
}

module show_points (p_list, c, d=0.2, auto=0)
{
	if (p_list!=undef)
	{
		size = len(p_list);
		for (i=[0:1:size-1])
		{
			show_point (p_list[i], get_debug_color(c,i,size), d, auto);
		}
	}
}
module show_points_colored (p_list, d=0.2, auto=0)
{
	show_points (p_list, true, d, auto);
}

module show_points_grid (p_list, c, d=0.2, auto=0)
{
	if (p_list!=undef)
	{
		size_i = len(p_list);
		for (i=[0:1:size_i-1])
		{
			size_j = len(p_list[i]);
			for (j=[0:1:size_j-1])
			{
				show_point (p_list[i][j], get_debug_color(c,i+j,size_i+size_j-1), d, auto);
			}
		}
	}
}
module show_points_grid_colored (p_list, d=0.2, auto=0)
{
	show_points_grid (p_list, true, d, auto);
}

module show_line (l, c, direction=false, d=0.1, auto=0)
{
	if (l!=undef)
	{
		D = get_debug_width (d,auto);
		if (direction!=true)
		{
			color (get_debug_color(c))
			%
			extrude_line (l, Z) circle(d=D, $fn=6);
		}
		else
		{
			L = [for (i=[0,1]) fill_missing_list (l[i], [0,0,0]) ];
			length = norm(L[1]-L[0]);
			arrow_length = length<5*D ? length : 5*D;
			arrow_ratio  = 3 / 5;
			
			if (length>arrow_length)
			{
				color (get_debug_color(c))
				%
				translate (L[0])
				rotate_to_vector (L[1]-L[0])
				cylinder (h=length-arrow_length, d=D, $fn=6);
			}
			
			color (get_debug_color(c))
			%
			translate (L[1])
			rotate_to_vector (L[0]-L[1])
			cylinder(h=arrow_length, d1=0, d2=arrow_length*arrow_ratio, $fn=6);
		}
	}
}

module show_lines (l_list, c, direction=false, d=0.1, auto=0)
{
	if (l_list!=undef)
	{
		size = len(l_list);
		for (i=[0:1:size-1])
		{
			show_line (l_list[i], get_debug_color(c,i,size), direction, d, auto);
		}
	}
}
module show_lines_colored (l_list, direction=false, d=0.1, auto=0)
{
	show_lines (l_list, true, direction, d, auto);
}

module show_vector (v, p, c, direction=true, d=0.1, auto=0)
{
	if (v!=undef)
	{
		P = p!=undef ? p : [for (i=[0:1:len(v)-1]) 0];
	
		show_line ([P, P+v], get_debug_color(c), direction, d, auto);
	}
}

module show_trace (p_list, c, closed=false, direction=false, d=0.1, p_factor=1.5, auto=0)
{
	if (p_list!=undef)
	{
		size = len(p_list);
		for (i=[0:1:size-1+(closed==true ? 0 : -1) ])
		{
			p1=p_list[ i        ];
			p2=p_list[(i+1)%size];
			
			if (p1!=p2)
				{ show_line ([p1, p2], get_debug_color(c,i,size), direction, d, auto); }
			else
				{ show_point (p1, get_debug_color(c,i,size), d*p_factor, auto); }
		}
	}
}
module show_trace_colored (p_list, closed=false, direction=false, d=0.1, p_factor=1.5, auto=0)
{
	show_trace (p_list, true, closed, direction, d, p_factor, auto);
}

module show_traces (p_lists, c, closed=false, direction=false, d=0.1, p_factor=1.5, auto=0)
{
	if (p_lists!=undef)
	{
		size = len(p_lists);
		for (i=[0:1:size-1])
		{
			show_trace (p_lists[i], get_debug_color(c,i,size), closed, direction, d, p_factor, auto);
		}
	}
}
module show_traces_colored (p_lists, closed=false, direction=false, d=0.1, p_factor=1.5, auto=0)
{
	show_traces (p_lists, true, closed, direction, d, p_factor, auto);
}

module show_label (txt, h=3.3, a=$vpr, valign="baseline", halign="left", auto=0)
{
	txt_breaks = split_str(txt, "\n");
	s = get_debug_width (h/15, auto);
	
    color     ("black")
	%
	rotate    (a)
	linear_extrude(0.01)
	for (i=[0:1:len(txt_breaks)-1])
		translate_y (-i * h)
		scale (s)
		text  (txt_breaks[i], valign=valign, halign=halign);
}

function get_debug_color (c, i, size, default="orange") =
	(c!=true || i==undef) ?
		c==undef || c==false ?
			default
		:	c
	:		color_hsv_to_rgb ([i/size*360,1,1])
;
function get_debug_width (d, auto=0) = d * ( (1-auto) + auto*$vpd/140 );

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
