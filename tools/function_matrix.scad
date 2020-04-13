// function_vector.scad 
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
function det (m) =
	let (size=len(m))
	(size>3) ?
		let (j=0)
		summation_list([ for (i=[0:size-1])
			(m[i][j]==0) ? 0 :
			m[i][j] * positiv_if_even(i+j)
			* det( matrix_minor(m, i, j) )
		])
	:(size==3) ? det_3x3(m)
	:(size==2) ? det_2x2(m)
	:(size==1) ? m[0][0]
	:undef
;
// Determinante einer quadratischen 2x2 - Matrix
function det_2x2 (m) = m[0][0]*m[1][1] - m[0][1]*m[1][0];
// Determinante einer quadratischen 3x3 - Matrix über das Spatprodukt ausrechnen
function det_3x3 (m) = cross(m[0], m[1]) * m[2];
;

// Aus der Matritze eine Zeile ausschneiden
function matrix_cut_row    (m, i) =
	let (size=len(m)) concat(
	(i  <=0)    ? [] : [ for (I=[0                       :min(i-1, size-1)]) m[I] ],
	(i+1>=size) ? [] : [ for (I=[max(0, min(i+1, size-1)):size-1          ]) m[I] ]
);
// Aus der Matritze eine Spalte ausschneiden
function matrix_cut_column (m, j) = [ for (I=[0:len(m)-1]) matrix_cut_row(m[I],j) ];
// Aus der Matritze eine Zeile und eine Spalte ausschneiden = Untermatrix
function matrix_minor      (m, i, j) = matrix_cut_column(matrix_cut_row(m, i), j);

// Matrix transponieren
function transpose (m) = [ for (i=[0:len(m[0])-1]) [ for(j=[0:len(m)-1]) m[j][i] ] ];

