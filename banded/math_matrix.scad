// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Hilfsfunktionen, zum Arbeiten mit Matritzen
//
//
// Hilfsfunktionen enthalten in OpenSCAD:
//
// norm()   - Betrag eines Vektors = die Länge des Vektors
// a[]+b[]  - Vektorielle Addition / Subtraktion
// a[]*b[]  - Skalarprodukt
// cross()  - Kreuzprodukt (Vektorielles Produkt)
//

use <banded/math_common.scad>
use <banded/list_algorithmus.scad>

// Gibt die Einheitsmatrix zurück in der Dimension n*n
function identity_matrix (n) =
	// die wichtigsten Einheitsmatritzen vordefiniert
	n==4 ? [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]] :
	n==3 ? [[1,0,0],[0,1,0],[0,0,1]] :
	n==2 ? [[1,0],[0,1]] :
	// Den Rest ausrechnen
	(!is_num(n)) ? undef :
	(n<1)        ? undef :
	[ for (i=[0:n-1])
	[ for (j=[0:n-1])
	(j==i) ? 1 : 0
	] ]
;


// Determinante berechnen
// Determinante einer  quadratischen Matrix mit den Laplaceschen Entwicklungssatz ausrechnen
// ab Größe 8x8 sehr langsam
function determinant (m) =
	let (size=len(m))
	(size>3) ?
		let (j=0)
		summation_list([ for (i=[0:size-1])
			if (m[i][j]!=0)
				m[i][j] * positiv_if_even(i+j)
				* determinant( matrix_minor(m, i, j) )
		])
	:(size==3) ? det_3x3(m)
	:(size==2) ? det_2x2(m)
	:(size==1) ? m[0][0]
	:undef
;
function det (m) = determinant (m);
// Determinante einer quadratischen 2x2 - Matrix
function det_2x2 (m) = m[0][0]*m[1][1] - m[0][1]*m[1][0];
// Determinante einer quadratischen 3x3 - Matrix über das Spatprodukt ausrechnen
function det_3x3 (m) =
	+ m[1][0] * (m[0][2]*m[2][1] - m[2][2]*m[0][1])
	+ m[1][1] * (m[0][0]*m[2][2] - m[2][0]*m[0][2])
	+ m[1][2] * (m[0][1]*m[2][0] - m[2][1]*m[0][0])
;
function det_3x3_2 (m) = cross(m[0], m[1]) * m[2];

// Aus der Matritze eine Zeile ausschneiden
function matrix_cut_row    (m, i) =
	let (size=len(m)) concat(
	(i  <=0)    ? [] : [ for (I=[0   :1:min(i-1, size-1)])           m[I] ],
	(i+1>=size) ? [] : [ for (I=[max(0, min(i+1, size-1)):1:size-1]) m[I] ]
);
// Aus der Matritze eine Spalte ausschneiden
function matrix_cut_column (m, j) = [ for (I=[0:1:len(m)-1]) matrix_cut_row(m[I],j) ];
// Aus der Matritze eine Zeile und eine Spalte ausschneiden = Untermatrix
function matrix_minor      (m, i, j) = matrix_cut_column(matrix_cut_row(m, i), j);

// In die Matritze m eine Zeile x in Position i einfügen
function matrix_insert_row    (m, x, i) =
	let (size=len(m)) concat(
	(i<=0)    ? [] : [ for (I=[0   :1:min(i-1, size-1)])         m[I] ],
	[x],
	(i>=size) ? [] : [ for (I=[max(0, min(i, size-1)):1:size-1]) m[I] ]
);
// In die Matritze m eine Spalte x in Position j einfügen
function matrix_insert_column (m, x, j) = [ for (I=[0:1:len(m)-1]) matrix_insert_row(m[I],x[I],j) ];

// In die Matritze m eine Zeile x in Position i ersetzen
function matrix_replace_row    (m, x, i) =
	let (size=len(m)) concat(
	(i<=0)           ? [] : [ for (I=[0   :1:min(i-1, size-1)])           m[I] ],
	(i>=size||(i<0)) ? [] : [x],
	(i+1>=size)      ? [] : [ for (I=[max(0, min(i+1, size-1)):1:size-1]) m[I] ]
);
// In die Matritze m eine Spalte x in Position j ersetzen
function matrix_replace_column (m, x, j) = [ for (I=[0:1:len(m)-1]) matrix_replace_row(m[I],x[I],j) ];

// an Matrix m in jeder Zeile Matrix a anhängen
function concat_matrix (m, a) =
	(m==undef || m[0][0]==undef) ? undef :
	(a==undef || a[0][0]==undef) ? m     :
	[ for (i=[0:1:len(m)-1]) concat (m[i],a[i]) ]
;


// Matrix transponieren
function transpose (m) = [ for (i=[0:1:len(m[0])-1]) [ for(j=[0:1:len(m)-1]) m[j][i] ] ];

// Matrix invertieren
function inverse (m) =
	let (
		identity = identity_matrix(len(m)),
		m1 = concat_matrix (m, identity),
		m2 = reduced_row_echelon_form  (m1)
	)
	!if_complete_main_diagonal(m2) ? undef : // matrix is not invertible
	let (
		m3 = back_substitution (m2),
		m4 = // remove identity matrix
			[ for (i=[0      :1:len(m3)-1])
			[ for (j=[len(m3):1:len(m3[0])-1])
				m3[i][j]
			] ]
	)
	m4
;

// Lineares Gleichungssystem lösen mit Koeffizientenmatrix
// m = nxn oder nxo matrix (o>n)
// a = nxp matrix, p = jede ganze Zahl >= 1,
//     optional, wird an m angehangen und zusammen ausgegeben
//     eine einfache Liste wird in eine Matrix umgewandelt und als Spalte angehangen
// clean - true  - Einheitsmatrix Teil entfernen, nur das Ergebnis
//       - false - Standart, Einheitsmatrix Teil drin lassen
function gauss_jordan_elimination (m, a, clean=false) =
	let(
		m1 = // append second list to first
			!is_list(m) || !is_list(m[0]) || !is_num(m[0][0]) ? undef :
			!is_list(a) ? m :
			is_list(a) && is_num(a[0]) && len(m)<=len(a) ?
				[ for (i=[0:1:len(m)-1]) concat(m[i],[a[i]]) ] :
			//	concat_matrix (m,transpose([a])) :
			is_list(a) && is_list(a[0]) && is_num(m[0][0]) && len(m)==len(a) ?
				concat_matrix (m,a) :
			m
		,m2 = // last check and calculation
			m1==undef         ? undef :
			len(m1)<=1        ? undef :
			len(m1)>len(m[0]) ? undef :
			back_substitution( reduced_row_echelon_form (m1) )
		,m3 = // maybe cut identity matrix part
			clean!=true ? m2 :
			m2==undef   ? undef :
			[ for (i=[0      :1:len(m2)-1])
			[ for (j=[len(m2):1:len(m2[0])-1])
				m2[i][j]
			] ]
	)
	m3
;
function reduced_row_echelon_form(m, i=0) =
	i>=len(m) ? m :
	let (
		p = get_first_nonzero (m, column=i, begin=i),
		//p = get_biggest_nonzero (m, column=i, begin=i),
		n = (p==i) ? m :
			matrix_replace_row(m, m[i]+m[p] ,i ),
		ni= (n[i][i]!=0) ? n[i]/n[i][i] : undef,
		c = (ni==undef) ? n :
			concat(
			[ for (j=[0:1:i-1]) n[j] ],
			[ ni ],
			[ for (j=[i+1:1:len(m)-1]) (n[j][i]!=0) ? n[j]/n[j][i]-ni : n[j] ]
			)
	)
	reduced_row_echelon_form(c, i+1)
;
function back_substitution(m, i=0) =
	i>=len(m) ? m :
	let (
		p = len(m)-1 - i,
		n = m[p][p]==0 ? m :
			concat (
			[ for (j=[0:1:p-1]) m[j][p]!=0 ? (m[j] - m[p]*m[j][p]/m[p][p]) : m[j] ],
			[ m[p] ],
			[ for (j=[p+1:1:len(m)-1]) m[j] ]
			)
	)
	back_substitution(n, i+1)
;

function get_first_nonzero (m, column=0, begin=0, i=0) =
	i>=len(m)-begin ? begin :
	m[begin+i][column]!=0 ? begin+i :
	get_first_nonzero (m, column, begin, i+1)
;
function get_biggest_nonzero (m, column=0, begin=0, i=0, value=0) =
	i>=len(m)-begin ? begin :
	m[begin+i][column]!=0 ?
		abs(m[begin+i][column])>abs(value) ?
			get_biggest_nonzero (m, column, begin+i,   0, m[begin+i][column])
		:	get_biggest_nonzero (m, column, begin,   i+1, value)
	:		get_biggest_nonzero (m, column, begin,   i+1, value)
;
function if_complete_main_diagonal (m) =
	len(m)==0 ? false :
	min ( [ for (i=[0:1:min(len(m),len(m[0]))-1]) abs(m[i][i]) ] ) != 0
;

