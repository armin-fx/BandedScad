// operator_edit.scad
//
// Enthält einige zusätzliche Operatoren zum Bearbeiten und Testen von Objekten
//
// Aufbau: modul() {Objekt(); <Objekt2; ...>}


// Setzt ein Objekt mit anderen Objekten zusammen
//
// Reihenfolge: Hauptobjekt(); zugefuegtes_Objekt(); abzuschneidendes_Objekt(); gemeinsames_Objekt();
//
module build ()
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
		union()
		{
			difference()
			{
				intersection()
					{
						children(0);
						children(3);
					}
				children(2);
			}
			children(1);
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
module object_pane (thickness=epsilon*2, size=[1000,1000])
{
	intersection()
	{
		children();
		//
		translate([-size[0]/2,-size[1]/2,-thickness/2])
			cube([size[0],size[1],thickness]);
	}
}


function get_trace_connect(trace) =
	concat ( [trace[len(trace)-1]], trace, [trace[0],trace[1]] )
;
range_connect=[1,-2];
//
function get_angle_between (ratio, a, b) =
	(a+b + ((abs(a-b)<180)?0:360) ) * ratio
;

//
module plain_trace_extrude (trace, range=[0,-1], convexity, lenght=1000, test=false)
{
	if (test) children();
	//
	begin = get_position(trace, range[0]);
	last  = get_position(trace, range[1]) - 1;
	overlap=epsilon;
	//
	for (i=[begin:last])
	{
		difference()
		{
			translate(trace[i])
			rotate([0,0,rotation_vector([0,-1], trace[i+1]-trace[i])])
			rotate([90,0,0]) linear_extrude(height=lenght, center=true, convexity=convexity) children();
			//
			translate(trace[i])
			rotate([0,0,
				(i==0) ?
					rotation_vector([0,-1], trace[i+1]-trace[i])
				:	get_angle_between(0.5, rotation_vector([0,-1], trace[i+1]-trace[i]), rotation_vector([0,-1], trace[i]-trace[i-1]))
			])
			translate([-lenght/2,overlap,-lenght/2]) cube([lenght,lenght,lenght]);
			//
			translate(trace[i+1])
			rotate([0,0,
				(i>=len(trace)-2) ?
					rotation_vector([0,-1], trace[i+1]-trace[i])
				:	get_angle_between(0.5, rotation_vector([0,-1], trace[i+1]-trace[i]), rotation_vector([0,-1], trace[i+2]-trace[i+1]))
			])
			translate([-lenght/2,-lenght-overlap,-lenght/2]) cube([lenght,lenght,lenght]);
		}
	}
}
module plain_trace_connect_extrude (trace, range=[0,-1], convexity, lenght=1000, test=false)
{
	plain_trace_extrude (
		trace=get_trace_connect(extract_list(trace, range=range))
		,range=range_connect, convexity=convexity, lenght=lenght, test=test
	) children();
}

/*
module trace_extrude (trace, rotation, convexity, lenght=1000)
{}
*/
