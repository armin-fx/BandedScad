// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Objekte, um Punkte und Linien anzeigen zu lassen
//

use <banded/operator_edit.scad>


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

module echo_list (list, pre="\t")
{
	echo( echo_list_helper_intern (list, pre) );
}
function echo_list_helper_intern (list, pre="\t", i=0, txt="") =
	i>=len(list) ? txt :
	echo_list_helper_intern (list, pre, i+1, str (txt ,"\n",pre, list[i]) )
;


// - Linien und Punkte sichtbar machen:

module show_point (p, c, d=0.2)
{
	if (p!=undef)
		color(c)
		translate(p)
		sphere(d=d, $fn=6);
}

module show_points (p_list, c, d=0.2)
{
	if (p_list!=undef)
		for (p=p_list) { show_point (p, c, d); }
}
module show_trace (p_list, c, closed=false, direction=false, d=0.1, dp=0.15)
{
	if (p_list!=undef)
	{
		size=len(p_list);
		for (i=[0:1:size-1+(closed==true ? 0 : -1) ])
		{
			p1=p_list[ i        ];
			p2=p_list[(i+1)%size];
			
			if (p1!=p2)
				{ show_line ([p1, p2], c, direction, d); }
			else
				{ show_point (p1, c, dp); }
		}
	}
}

module show_line (l, c, direction=false, d=0.1)
{
	if (l!=undef)
	{
		if (direction!=true)
		{
			color(c)
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
				color(c)
				translate (L[0])
				rotate_to_vector (L[1]-L[0])
				cylinder (h=length-arrow_length, d=d, $fn=6);
			}
			
			color(c)
			translate (L[1])
			rotate_to_vector (L[0]-L[1])
			cylinder(h=arrow_length, d1=0, d2=arrow_length*arrow_ratio, $fn=6);
		}
	}
}

module show_lines (l_list, c, direction=false, d=0.1)
{
	if (l_list!=undef)
		for (l=l_list) { show_line (l, c, direction, d); }
}

module show_vector (v, p, c, direction=true, d=0.1)
{
	if (v!=undef)
	{
		P = p!=undef ? p : [for (i=[0:1:len(v)-1]) 0];
	
		show_line ([P, P+v], c, direction, d);
	}
}


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
