// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Problem beschrieben von dieser Seite
// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
//
// Die Argumente der Objekte sind die selben wie die Objekte von OpenSCAD,
// auf denen sie basieren.
//
// Aufbau:
//    <Basisobjekt>_outer  - Das erzeugte Objekt ist immer größer als das reale Objekt
//                           Die Kanten stoßen von außen an das reale Objekt
//    <Basisobjekt>_middle - Das erzeugte Objekt ist im Mittel so groß wie das reale Objekt
//    <Basisobjekt>        - Das erzeugte Objekt ist immer kleiner als das reale Objekt
//                           Die Ecken stoßen von innen an das reale Objekt

use <banded/extend.scad>
use <banded/helper_recondition.scad>

// 2D

// circle ()
module circle_middle (r, d)
{
	rx = parameter_circle_r (r, d);
	fn = get_fn_circle_current (rx);
	fudge = (1+1/cos(180/fn))/2;
	circle(r=r*fudge, $fn=fn);
}

module circle_outer (r, d)
{
	rx = parameter_circle_r (r, d);
	fn = get_fn_circle_current (rx);
	fudge = 1/cos(180/fn);
	circle (r=r*fudge, $fn=fn);
}

// 3D

// cylinder ()
module cylinder_middle (h=1, r1, r2, center, r, d, d1, d2)
{
	ra = parameter_cylinder_r (r, r1, r2, d, d1, d2);
	ra1= ra[0];
	ra2= ra[1];
	fn = get_fn_circle_current (max (ra1, ra2));
	fudge = (1+1/cos(180/fn))/2;
	cylinder (h=h, r1=ra1*fudge, r2=ra2*fudge, center=center, $fn=fn);
}

module cylinder_outer (h=1, r1, r2, center, r, d, d1, d2)
{
	ra = parameter_cylinder_r (r, r1, r2, d, d1, d2);
	ra1= ra[0];
	ra2= ra[1];
	fn = get_fn_circle_current (max (ra1, ra2));
	fudge = 1/cos(180/fn);
	cylinder (h=h, r1=ra1*fudge, r2=ra2*fudge, center=center, $fn=fn);
}

// sphere ()
module sphere_middle (r, d)
{
	rx = parameter_circle_r (r, d);
	fn = get_fn_circle_current (rx);
	fn_polar= ceil(fn / 2) * 2;
	fudge_pol = (1+1/cos(180/fn_polar))/2;
	fudge_mid = (1+1/cos(180/fn))/2;
	fudge_all = fudge_pol * fudge_mid;
	scale ([fudge_all,fudge_all,fudge_pol])
		sphere (r=rx, $fn=fn);
}

module sphere_outer (r, d)
{
	rx = parameter_circle_r (r, d);
	fn = get_fn_circle_current (rx);
	fn_polar= ceil(fn / 2) * 2;
	fudge_pol = 1/cos(180/fn_polar);
	fudge_mid = 1/cos(180/fn);
	fudge_all = fudge_pol * fudge_mid;
	//scale (fudge_pol)
	scale ([fudge_all,fudge_all,fudge_pol])
		sphere (r=rx, $fn=fn);
}

