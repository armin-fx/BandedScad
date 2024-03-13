// Copyright (c) 2024 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen, um Argumente von Funktionen
// um weitere Steuerungsmöglichkeiten zu erweitern


// Stellt den Parameter 'angle' ein.
// Öffnungswinkel eines Halbkreises im mathematischen Drehsinn = entgegen den Uhrzeigersinn
//
// Rückgabe:
// - Liste '[ Öffnungswinkel, Startwinkel ]'
//
// Argumente
// - opening - Öffnungswinkel (Mittelpunktswinkel)
// - outer   - entgegengesetzter Öffnungswinkel (360° - Mittelpunktswinkel)
// - begin   - Anfangswinkel des Halbkreises
// - end     - Endwinkel des Halbkreises
//
// Priorität der Argumente:
// - opening, begin
// - opening, end
// - outer, begin
// - outer, end
// - begin, end
// - fehlende Werte mit Standartwert [360, 0] auffüllen
//
// TODO prüfen nach negative Winkel
function configure_angle (opening, begin, end, outer) =
	 (opening!=undef && begin!=undef) ? [opening  , begin]
	:(opening!=undef && end  !=undef) ? [opening  , end-opening]
	:(outer  !=undef && begin!=undef) ? [360-outer, begin]
	:(outer  !=undef && end  !=undef) ? [360-outer, end-(360-outer)]
	:(begin  !=undef && end  !=undef) ? [end-begin, begin]
	:(opening!=undef) ? [opening  , 0]
	:(outer  !=undef) ? [360-outer, 0]
	:(begin  !=undef) ? [360, begin]
	:(end    !=undef) ? [360, end]
	:[360, 0]
;

// Stellt den Parameter 'edges' vom Module cube_fillet() ein.
//
// 3 Gruppen von Kanten, die den Quader jeweils vollständig umfassen:
// - bottom, top, around
// - left, right, forward
// - front, back, sideways
// In den 3 Gruppen werden alle Kanten jeweils 3 mal definiert werden,
// daher gibt es eine Priorität, die höhere überschreibt die niedrige.
// Einzelne Kanten können mit 'undef' als nicht definiert gesetzt werden.
// Reihenfolge, weiter links liegende überschreibt weiter rechts liegende:
// - bottom, top, around,  left, right, forward,  front, back, sideways
//
// Argumente:
// - 'bottom'   - 4 Kanten um das Rechteck am Boden    - 1. Kante = vorne,       links herum von oben gesehen
// - 'top'      - 4 Kanten um das Rechteck am Dach     - 1. Kante = vorne,       links herum von oben gesehen
// - 'around'   - 4 Kanten vertikal vom Boden zum Dach - 1. Kante = vorne links, links herum von oben gesehen
// - 'left'     - 4 Kanten um das Rechteck linke Seite      - 1. Kante = links unten,  links herum von links gesehen
// - 'right'    - 4 Kanten um das Rechteck rechte Seite     - 1. Kante = rechts unten, links herum von links gesehen
// - 'forward'  - 4 Kanten horizontal von links nach rechts - 1. Kante = vorne unten,  links herum von links gesehen
// - 'front'    - 4 Kanten um das Rechteck vordere Seite    - 1. Kante = vorne unten,  links herum von vorne gesehen
// - 'back'     - 4 Kanten um das Rechteck hintere Seite    - 1. Kante = hinten unten, links herum von vorne gesehen
// - 'sideways' - 4 Kanten horizontal von vorne nach hinten - 1. Kante = rechts unten, links herum von vorne gesehen
// - 'r'        - optionaler Parameter
//                Alle Kanten werden mit diesen Wert multipliziert, wenn angegeben.
// - 'default'  - Wert, der genommen wird, für Kanten die nicht gesetzt wurden
//              - Standart = 0, Kante nicht abgerundet
// Rückgabe:
// - 12 Element Liste:
//   - die ersten 4 Elemente entsprechen:        'bottom' - alle 4 Kanten am Boden
//   - die nachfolgenden 4 Elemente entsprechen: 'top'    - alle 4 Kanten oben
//   - die letzten 4 Elemente entsprechen:       'around' - alle vertikalen Kanten an der Seite
//
function configure_edges (bottom,top,around, left,right,forward, front,back,sideways, r, default=0) =
	let (
		 Bottom = configure_edges_prepare (bottom)
		,Top    = configure_edges_prepare (top)
		,Around = configure_edges_prepare (around)
		,Left    = configure_edges_prepare (left)
		,Right   = configure_edges_prepare (right)
		,Forward = configure_edges_prepare (forward)
		,Front    = configure_edges_prepare (front)
		,Back     = configure_edges_prepare (back)
		,Sideways = configure_edges_prepare (sideways)
		//
		,edges_bottom = configure_edges_priority
			( Bottom
			, [ Forward[0], Right   [0], Forward[3], Left    [0] ]
			, [ Front  [0], Sideways[0], Back   [0], Sideways[3] ]
			)
		,edges_top = configure_edges_priority
			( Top
			, [ Forward[1], Right   [2], Forward[2], Left    [2] ]
			, [ Front  [2], Sideways[1], Back   [2], Sideways[2] ]
			)
		,edges_around = configure_edges_priority
			( Around
			, [ Left [1], Right[1], Right[3], Left[3] ]
			, [ Front[3], Front[1], Back [1], Back[3] ]
			)
	)
	[ each configure_edges_radius (edges_bottom, r, default)
	, each configure_edges_radius (edges_top   , r, default)
	, each configure_edges_radius (edges_around, r, default)
	]
;
function configure_edges_prepare (edges, n=4) =
	 is_num (edges) ? [for (i=[0:1:n-1]) edges   ]
	:is_list(edges) ? [for (i=[0:1:n-1]) edges[i]]
	:                 [for (i=[0:1:n-1]) undef  ]
;
function configure_edges_priority (edges1, edges2, edges3, n=4) =
	[ for (i=[0:1:n-1])
		edges1[i]!=undef ? edges1[i] :
		edges2[i]!=undef ? edges2[i] :
		edges3[i]!=undef ? edges3[i] :
		undef
	]
;
function configure_edges_radius (edges, r, default=0) =
	(r==undef) || !is_num(r) ?
		[ for (i=[0:1:len(edges)-1]) edges[i]==undef ? default : edges[i] ]
	:	[ for (i=[0:1:len(edges)-1]) edges[i]==undef ? default : edges[i] ] * r
;

// Stellt den Parameter 'types' vom Module cube_fillet() ein.
//
// Argumente wie bei 'configure_edges()', nur ohne r
function configure_types (bottom,top,around, left,right,forward, front,back,sideways, default=0) =
	configure_edges (bottom,top,around, left,right,forward, front,back,sideways, undef, default)
;

// Stellt den Parameter 'corner' vom Module cube_fillet() ein.
//
// 3 Gruppen von Ecken, die den Quader jeweils vollständig umfassen:
// - bottom, top
// - left, right
// - front, back
// In den 3 Gruppen werden alle Ecken jeweils 3 mal definiert werden,
// daher gibt es eine Priorität, die höhere überschreibt die niedrige.
// Einzelne Ecken können mit 'undef' als nicht definiert gesetzt werden.
// Reihenfolge, weiter links liegende überschreibt weiter rechts liegende:
// - bottom, top,  left, right,  front, back
//
// Argumente:
// - 'bottom'   - 4 Ecken um das Rechteck am Boden      - 1. Ecken = vorne links,  links herum von oben gesehen
// - 'top'      - 4 Ecken um das Rechteck am Dach       - 1. Ecken = vorne links,  links herum von oben gesehen
// - 'left'     - 4 Ecken um das Rechteck linke Seite   - 1. Ecken = vorne unten,  links herum von links gesehen
// - 'right'    - 4 Ecken um das Rechteck rechte Seite  - 1. Ecken = vorne unten,  links herum von links gesehen
// - 'front'    - 4 Ecken um das Rechteck vordere Seite - 1. Ecken = rechts unten, links herum von vorne gesehen
// - 'back'     - 4 Ecken um das Rechteck hintere Seite - 1. Ecken = rechts unten, links herum von vorne gesehen
// - 'default'  - Wert, der genommen wird, für Ecken die nicht gesetzt wurden
//              - Standart = 0, Ecken nicht abgerundet
// Rückgabe:
// - 8 Element Liste:
//   - die ersten 4 Elemente entsprechen:  'bottom' - alle 4 Ecken am Boden
//   - die letzten 4 Elemente entsprechen: 'top'    - alle 4 Ecken oben
//
function configure_corner (bottom,top, left,right, front,back, default=0) =
	let (
		 Bottom = configure_edges_prepare (bottom)
		,Top    = configure_edges_prepare (top)
		,Left    = configure_edges_prepare (left)
		,Right   = configure_edges_prepare (right)
		,Front    = configure_edges_prepare (front)
		,Back     = configure_edges_prepare (back)
		//
		,edges_bottom = configure_edges_priority
			( Bottom
			, [ Left [0], Right[0], Right[3], Left[3] ]
			, [ Front[3], Front[0], Back [0], Back[3] ]
			)
		,edges_top = configure_edges_priority
			( Top
			, [ Left [1], Right[1], Right[2], Left[2] ]
			, [ Front[2], Front[1], Back [1], Back[2] ]
			)
	)
	[ each configure_edges_radius (edges_bottom, undef, default)
	, each configure_edges_radius (edges_top   , undef, default)
	]
;

