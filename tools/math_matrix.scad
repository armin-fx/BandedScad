// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Hilfsfunktionen, zum Arbeiten mit Matritzen
//
//
// Hilfsfunktionen enthalten in OpenScad:
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
	(!is_num(n)) ? undef :
	(n<1)        ? undef :
	[ for (i=[0:n-1])
	[ for (j=[0:n-1])
	(j==i) ? 1 : 0
	] ]
;
// die wichtigsten Einheitsmatritzen vordefiniert
identity_matrix = [
	identity_matrix(0),
	identity_matrix(1),
	identity_matrix(2),
	identity_matrix(3),
	identity_matrix(4)
];


// Determinante berechnen
// Determinante einer  quadratischen Matrix mit den Laplaceschen Entwicklungssatz ausrechnen
// ab Größe 8x8 sehr langsam
function determinant (m) =
	let (size=len(m))
	(size>3) ?
		let (j=0)
		summation_list([ for (i=[0:size-1])
			(m[i][j]==0) ? 0 :
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
function det_3x3 (m) = cross(m[0], m[1]) * m[2];
;

// Aus der Matritze eine Zeile ausschneiden
function matrix_cut_row    (m, i) =
	let (size=len(m)) concat(
	(i  <=0)    ? [] : [ for (I=[0     :min(i-1, size-1)])         m[I] ],
	(i+1>=size) ? [] : [ for (I=[max(0, min(i+1, size-1)):size-1]) m[I] ]
);
// Aus der Matritze eine Spalte ausschneiden
function matrix_cut_column (m, j) = [ for (I=[0:len(m)-1]) matrix_cut_row(m[I],j) ];
// Aus der Matritze eine Zeile und eine Spalte ausschneiden = Untermatrix
function matrix_minor      (m, i, j) = matrix_cut_column(matrix_cut_row(m, i), j);

// In die Matritze m eine Zeile x in Position i einfügen
function matrix_insert_row    (m, x, i) =
	let (size=len(m)) concat(
	(i<=0)    ? [] : [ for (I=[0     :min(i-1, size-1)])       m[I] ],
	[x],
	(i>=size) ? [] : [ for (I=[max(0, min(i, size-1)):size-1]) m[I] ]
);
// In die Matritze m eine Spalte x in Position j einfügen
function matrix_insert_column (m, x, j) = [ for (I=[0:len(m)-1]) matrix_insert_row(m[I],x[I],j) ];

// In die Matritze m eine Zeile x in Position i ersetzen
function matrix_replace_row    (m, x, i) =
	let (size=len(m)) concat(
	(i<=0)           ? [] : [ for (I=[0     :min(i-1, size-1)])         m[I] ],
	(i>=size||(i<0)) ? [] : [x],
	(i+1>=size)      ? [] : [ for (I=[max(0, min(i+1, size-1)):size-1]) m[I] ]
);
// In die Matritze m eine Spalte x in Position j ersetzen
function matrix_replace_column (m, x, j) = [ for (I=[0:len(m)-1]) matrix_replace_row(m[I],x[I],j) ];

// an Matrix a in jeder Zeile Matrix b anhängen
function concat_matrix (a,b) =
	a[0][0]==undef ? undef :
	b[0][0]==undef ? a     :
	[ for (i=[0:len(a)-1]) concat (a[i],b[i]) ]
;


// Matrix transponieren
function transpose (m) = [ for (i=[0:len(m[0])-1]) [ for(j=[0:len(m)-1]) m[j][i] ] ];

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
			[ for (i=[0      :len(m3)-1])
			[ for (j=[len(m3):len(m3[0])-1])
				m3[i][j]
			] ]
	)
	m4
;

// Lineares Gleichungssystem lösen mit Koeffizientenmatrix
// a = nxn oder nxm matrix (m>n)
// b = nxo matrix, o = jede ganze Zahl >= 1,
//     optional, wird an a angehangen und zusammen ausgegeben
//     eine einfache Liste wird in eine Matrix umgewandelt und als Spalte angehangen
function gauss_jordan_elimination (a, b) =
	let(
		m =	!is_list(a) || !is_list(a[0]) || !is_num(a[0][0]) ? undef :
			!is_list(b) ? a :
			is_list(b) && is_num(b[0]) && len(a)<=len(b) ?
				[ for (i=[0:len(a)-1]) concat(a[i],[b[i]]) ] :
			//	concat_matrix (a,transpose([b])) :
			is_list(b) && is_list(b[0]) && is_num(a[0][0]) && len(a)==len(b) ?
				concat_matrix (a,b) :
			a
	)
	m==undef         ? undef :
	len(m)<=1        ? undef :
	len(m)>len(m[0]) ? undef :
	back_substitution( reduced_row_echelon_form (m) )
;
function reduced_row_echelon_form(a, i=0) =
	i>=len(a) ? a :
	let (
		p = get_first_nonzero (a, column=i, begin=i),
		//p = get_biggest_nonzero (a, column=i, begin=i),
		b = (p==i) ? a :
			matrix_replace_row(a, a[i]+a[p] ,i ),
		bi= (b[i][i]!=0) ? b[i]/b[i][i] : undef,
		c = (bi==undef) ? b :
			concat(
			[ for (j=[0:1:i-1]) b[j] ],
			[ bi ],
			[ for (j=[i+1:1:len(a)-1]) (b[j][i]!=0) ? b[j]/b[j][i]-bi : b[j] ]
			)
	)
	reduced_row_echelon_form(c, i+1)
;
function back_substitution(a, i=0) =
	i>=len(a) ? a :
	let (
		p = len(a)-1 - i,
		b = a[p][p]==0 ? a :
			concat (
			[ for (j=[0:1:p-1]) a[j][p]!=0 ? (a[j] - a[p]*a[j][p]/a[p][p]) : a[j] ],
			[ a[p] ],
			[ for (j=[p+1:1:len(a)-1]) a[j] ]
			)
	)
	back_substitution(b, i+1)
;

function get_first_nonzero (a, column=0, begin=0, i=0) =
	i>=len(a)-begin ? begin :
	a[begin+i][column]!=0 ? begin+i :
	get_first_nonzero (a, column, begin, i+1)
;
function get_biggest_nonzero (a, column=0, begin=0, i=0, value=0) =
	i>=len(a)-begin ? begin :
	a[begin+i][column]!=0 ?
		abs(a[begin+i][column])>abs(value) ?
			get_biggest_nonzero (a, column, begin+i,   0, a[begin+i][column])
		:	get_biggest_nonzero (a, column, begin,   i+1, value)
	:		get_biggest_nonzero (a, column, begin,   i+1, value)
;
function if_complete_main_diagonal (m) =
	len(m)==0 ? false :
	min ( [ for (i=[0:min(len(m),len(m[0]))-1]) abs(m[i][i]) ] ) != 0
;

