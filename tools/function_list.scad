// function_list.scad
//
// Enthält Funktionen zum Bearbeiten von Listen und Punktlisten


// verbindet einzelne Listen innerhalb einer Liste miteinander
// aus z.B  [ [1,2,3], [4,5] ]  wird  [1,2,3,4,5]
function concat_list (list) = [for (a=list) for (b=a) b];

// kehrt die Reihenfolge einer Liste um
function reverse_list (list) = [for (a=[len(list)-1:-1:0]) list[a]];


// Listenfunktionen

// gibt den Wert eines angegebenen Typs zurück
// Typen:
//     0     = normaler Wert
//     1...n = Liste mit Position [1,2,3]
// Wird in den folgenden Listenfunktionen verwendet,
// um zwischen den Daten umschalten zu können von außerhalb der Funktion
function get_value (v, type=0) = (type==0) ? v : v[type-1];

// Gibt eine Liste des gewählten Typs zurück
function value_list (list, type=0) = [for (e=list) get_value(e, type)];

// Maximum oder Minimum einer Liste gemäß des Typs
function min_list(list, type=0) = (type==0) ? min(list) : min(value_list(list, type));
function max_list(list, type=0) = (type==0) ? max(list) : max(value_list(list, type));

// Listen sortieren
function sort_list (list, type=0) = sort_list_mergesort (list, type);

// unstabiles sortieren
function sort_list_quicksort (list, type=0) =
	!(len(list)>0) ? [] : let(
		pivot   = get_value( list[floor(len(list)/2)] ,type),
		lesser  = [ for (e = list) if (get_value(e,type)  < pivot) e ],
		equal   = [ for (e = list) if (get_value(e,type) == pivot) e ],
		greater = [ for (e = list) if (get_value(e,type)  > pivot) e ]
	) concat(
		sort_list_quicksort(lesser,type), equal, sort_list_quicksort(greater,type)
	)
;


// stabiles sortierten
function sort_list_mergesort (list, type=0) =
	(len(list)<=1) ? list :
	let(end=len(list)-1, middle=floor((len(list)-1)/2))
	merge_sorted_list(
		 sort_list_mergesort([for (i=[0:middle])     list[i]], type)
		,sort_list_mergesort([for (i=[middle+1:end]) list[i]], type)
		,type
	)
;

// 2 sortierte Listen miteinander verschmelzen
function merge_sorted_list        (list1, list2, type=0) = merge_sorted_list_intern (list1, list2, type);
function merge_sorted_list_intern (list1, list2, type, i1=0, i2=0) =
	(i1>=len(list1) || i2>=len(list2)) ?
		(i1>=len(list1)) ? [ for (e=[i2:len(list2)-1]) list2[e] ]
	:	(i2>=len(list2)) ? [ for (e=[i1:len(list1)-1]) list1[e] ]
	:   []
	:(get_value(list1[i1],type) <= get_value(list2[i2],type)) ?
		 concat([list1[i1]], merge_sorted_list_intern (list1, list2, type, i1+1, i2))
		:concat([list2[i2]], merge_sorted_list_intern (list1, list2, type, i1,   i2+1))
;

function binary_search        (list, v, type=0) = (len(list)<=1) ? 0 : binary_search_intern (list, v, type, 0, len(list)-1);
function binary_search_intern (list, v, type, begin, end) =
	(end<begin)        ? -begin
	:let(middle=floor((begin+end)/2))
	 (get_value(list[middle])==v) ? middle
	:(get_value(list[middle])< v) ? binary_search_intern (list, v, middle+1, end)
	:                               binary_search_intern (list, v, begin   , middle-1)
;


// pair-Funktionen
//
// Aufbau eines Paares: [key, value]
// list = Liste mehrerer Schlüssel-Wert-Paare z.B. [ [key1,value1], [key2,value2], ... ]

// Typ-Konstanten für die Listenfunktionen
type_pair_key  =1;
type_pair_value=2;

// gibt den Wert eines Schlüssels aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Schlüssel zum Wert
//   index   -Bei gleichen Schlüsselwerten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function pair_value        (list, key, index=0) = pair_value_intern(list, key, index);
function pair_value_intern (list, key, index, n=0) =
	(list[n]==undef) ? undef
	:(list[n][0]==key) ?
		(index==0) ? list[n][1]
		:	pair_value_intern (list, key, index-1, n+1)
	:		pair_value_intern (list, key, index,   n+1)
;

// gibt den Schlüssel eines Wertes aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Wert zum Schlüssel
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Wert genommen (index=0)
function pair_key        (list, value, index=0) = pair_key_intern(list, value, index);
function pair_key_intern (list, value, index, n=0) =
	(list[n]==undef) ? undef
	:(list[n][1]==value) ?
		(index==0) ? list[n][0]
		:	pair_key_intern (list, value, index-1, n+1)
	:		pair_key_intern (list, value, index,   n+1)
;

// erzeugt ein Schlüssel-Werte-Paare
function pair (key, value) = [key, value];


