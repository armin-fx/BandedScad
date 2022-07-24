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
module show_trace (p_list, c, closed=false, d=0.1, dp=0.15)
{
	if (p_list!=undef)
	{
		size=len(p_list);
		for (i=[0:1:size-1+(closed==true ? 0 : -1) ])
		{
			p1=p_list[ i        ];
			p2=p_list[(i+1)%size];
			
			if (p1!=p2)
				{ show_line ([p1, p2], c, d); }
			else
				{ show_point (p1, c, dp); }
		}
	}
}

module show_line (l, c, d=0.1)
{
	if (l!=undef)
		color(c)
		extrude_line (l) circle(d=d, $fn=6);
}

module show_lines (l_list, c, d=0.1)
{
	if (l_list!=undef)
		for (l=l_list) { show_line (l, c, d); }
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
