// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen mit Zugriff auf den Inhalt
//
// Die Funktionen für typabhängigen Zugriff wurden zum Teil inline eingesetzt
// um die Ausführgeschwindigkeit zu erhöhen,
// lässt sich bei Änderungen an den internen Typdaten aber schlecht warten.
// Funktionsaufrufe sind teuer.
// Außerdem wurden für jeden bekannten Typ eine eigene Version der Funktion
// erstellt, aus dem selben Grund.

use <banded/helper.scad>

use <banded/list_edit_type.scad>


// Maximum oder Minimum einer Liste gemäß des Typs
function min_list (list, type=0) = min (value_list(list, type));
function max_list (list, type=0) = max (value_list(list, type));

// Position des kleinsten Wertes einer Liste gemäß des Typs zurückgeben
function min_position (list, type=0) =
	list==undef ? -1 :
	 type   == 0 ? min_position_intern_direct   (list)
	:type[0]>= 0 ? min_position_intern_list     (list, type[0])
	:type[0]==-1 ? min_position_intern_function (list, type[1])
	:              min_position_intern_type     (list, type)
;
function min_position_intern_direct (list, pos=0, i=0) =
	i>=len(list) ? pos :
	min_position_intern_direct (list
		,list[pos]<=list[i] ? pos : i
		,i+1
		)
;
function min_position_intern_list (list, position=0, pos=0, i=0) =
	i>=len(list) ? pos :
	min_position_intern_list (list, position
		,list[pos][position]<=list[i][position] ? pos : i
		,i+1
		)
;
function min_position_intern_function (list, fn, pos=0, i=0) =
	i>=len(list) ? pos :
	min_position_intern_function (list, fn
		,fn(list[pos])<=fn(list[i]) ? pos : i
		,i+1
		)
;
function min_position_intern_type (list, type, pos=0, i=0) =
	i>=len(list) ? pos :
	min_position_intern_type (list, type
		,get_value(list[pos],type)<=get_value(list[i],type) ? pos : i
		,i+1
		)
;

// Position des größten Wertes einer Liste gemäß des Typs zurückgeben
function max_position (list, type=0) =
	list==undef ? -1 :
	 type   ==0 ? max_position_intern_direct (list)
	:type[0]>=0 ? max_position_intern_list   (list, type[0])
	:             max_position_intern_type   (list, type)
;
function max_position_intern_direct (list, pos=0, i=0) =
	i>=len(list) ? pos :
	max_position_intern_direct (list
		,list[pos]>=list[i] ? pos : i
		,i+1
		)
;
function max_position_intern_list (list, position=0, pos=0, i=0) =
	i>=len(list) ? pos :
	max_position_intern_list (list, position
		,list[pos][position]>=list[i][position] ? pos : i
		,i+1
		)
;
function max_position_intern_function (list, fn, pos=0, i=0) =
	i>=len(list) ? pos :
	max_position_intern_function (list, fn
		,fn(list[pos])>=fn(list[i]) ? pos : i
		,i+1
		)
;
function max_position_intern_type (list, type, pos=0, i=0) =
	i>=len(list) ? pos :
	max_position_intern_type (list, type
		,get_value(list[pos],type)>=get_value(list[i],type) ? pos : i
		,i+1
		)
;

// Listen sortieren
function sort (list, type=0) = sort_quicksort (list, type);

// stabiles sortieren mit Quicksort
function sort_quicksort (list, type=0) =
	list==undef ? list :
	 type   ==0 ? sort_quicksort_direct (list)
	:type[0]>=0 ? sort_quicksort_list   (list, type[0])
	:             sort_quicksort_type   (list, type)
;
function sort_quicksort_direct (list) =
	!(len(list)>1) ? list :
	let(
		pivot   = list[floor(len(list)/2)],
		lesser  = [ for (e=list) if (e  < pivot) e ],
		equal   = [ for (e=list) if (e == pivot) e ],
		greater = [ for (e=list) if (e  > pivot) e ]
	) concat(
		sort_quicksort_direct(lesser), equal, sort_quicksort_direct(greater)
	)
;
function sort_quicksort_list (list, position=0) =
	!(len(list)>1) ? list :
	let(
		pivot   = list[floor(len(list)/2)][position],
		lesser  = [ for (e=list) if (e[position]  < pivot) e ],
		equal   = [ for (e=list) if (e[position] == pivot) e ],
		greater = [ for (e=list) if (e[position]  > pivot) e ]
	) concat(
		sort_quicksort_list(lesser,position), equal, sort_quicksort_list(greater,position)
	)
;
function sort_quicksort_type (list, type) =
	!(len(list)>1) ? list :
	let(
		pivot   = get_value( list[floor(len(list)/2)] ,type),
		lesser  = [ for (e=list) if (get_value(e,type)  < pivot) e ],
		equal   = [ for (e=list) if (get_value(e,type) == pivot) e ],
		greater = [ for (e=list) if (get_value(e,type)  > pivot) e ]
	) concat(
		sort_quicksort_type(lesser,type), equal, sort_quicksort_type(greater,type)
	)
;

// stabiles sortierten mit Mergesort
function sort_mergesort (list, type=0) =
	list==undef || !(len(list)>1) ? list :
	(len(list)==2) ?
		get_value(list[0],type)<get_value(list[1],type) ?
			[list[0],list[1]] : [list[1],list[0]] :
	let(end=len(list)-1, middle=floor((len(list)-1)/2))
	merge(
		 sort_mergesort([for (i=[0:middle])     list[i]], type)
		,sort_mergesort([for (i=[middle+1:end]) list[i]], type)
		,type
	)
;

// 2 sortierte Listen miteinander verschmelzen
// sehr langsame Implementierung
function merge        (list1, list2, type=0) =
	list1==undef ? list2 :
	list2==undef ? list1 :
	merge_intern_2 (list1, list2, type)
;
function merge_intern (list1, list2, type=0, i1=0, i2=0) =
	(i1>=len(list1) || i2>=len(list2)) ?
		(i1>=len(list1)) ? [ for (e=[i2:len(list2)-1]) list2[e] ]
	:	(i2>=len(list2)) ? [ for (e=[i1:len(list1)-1]) list1[e] ]
	:   []
	:(get_value(list1[i1],type) <= get_value(list2[i2],type)) ?
		 concat([list1[i1]], merge_intern (list1, list2, type, i1+1, i2))
		:concat([list2[i2]], merge_intern (list1, list2, type, i1,   i2+1))
;
function merge_intern_2 (list1, list2, type=0) =
	let(
		enda=len(list1),
		endb=len(list2)
	)
	!(enda>0) ? list2 :
	!(endb>0) ? list1 :
	let (
		a=list1,
		b=list2,
		end=enda+endb - 1
	)
	[for (
		i=0,j=0,
			A=get_value(a[i],type),
			B=get_value(b[j],type),
			q=j>=endb?true:A<B, v=q?a[i]:b[j]
		;i+j<=end;
		i=q?i+1:i, j=q?j:j+1,
			A=get_value(a[i],type),
			B=get_value(b[j],type),
			q=j>=endb?true:A<B, v=q?a[i]:b[j]
	) v ]
;

// sucht einen Wert in einer aufsteigend sortierten Liste und gibt die Position zurück.
// Gibt einen negativen Wert zurück, wenn nichts gefunden wurde. Der Betrag des Wertes
// ist die letzte Position, wo gesucht wurde.
function binary_search        (list, value, type=0) =
	list==undef || len(list)<=1 ? 0 :
	binary_search_intern (list, value, type, 0, len(list)-1)
;
function binary_search_intern (list, value, type, begin, end) =
	(end<begin)        ? -begin
	:let(
		middle=floor((begin+end)/2),
		v=get_value(list[middle],type)
	)
	 (v==value) ? middle
	:(v< value) ? binary_search_intern (list, value, type, middle+1, end)
	:             binary_search_intern (list, value, type, begin   , middle-1)
;

// sucht nach einem Wert und gibt die Position des Treffers aus einer Liste heraus
// Die Liste wird vom Anfang aus durchsucht
// Wurde der Wert nicht gefunden, wird die Position nach dem letzten Element zurückgegeben
// Argumente:
//   list    -Liste
//   value   -gesuchter Wert
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function find_first (list, value, index=0, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	index==0 ? find_first_once_intern (list, value, type, Range[0], Range[1]) :
	//
	 type   == 0 ? find_first_intern_direct   (list, value, index         , Range[0], Range[1])
	:type[0]>= 0 ? find_first_intern_list     (list, value, index, type[0], Range[0], Range[1])
	:type[0]==-1 ? find_first_intern_function (list, value, index, type[1], Range[0], Range[1])
	:              find_first_intern_type     (list, value, index, type   , Range[0], Range[1])
;
function find_first_intern_direct (list, value, index=0, n=0, last=-1) =
	(n>last) ? n :
	(list[n]==value) ?
		(index==0) ? n
		:	find_first_intern_direct (list, value, index-1, n+1, last)
	:		find_first_intern_direct (list, value, index,   n+1, last)
;
function find_first_intern_list (list, value, index=0, position=0, n=0, last=-1) =
	(n>last) ? n :
	(list[n][position]==value) ?
		(index==0) ? n
		:	find_first_intern_list (list, value, index-1, position, n+1, last)
	:		find_first_intern_list (list, value, index,   position, n+1, last)
;
function find_first_intern_function (list, value, index=0, fn, n=0, last=-1) =
	(n>last) ? n :
	(fn(list[n])==value) ?
		(index==0) ? n
		:	find_first_intern_function (list, value, index-1, fn, n+1, last)
	:		find_first_intern_function (list, value, index,   fn, n+1, last)
;
function find_first_intern_type (list, value, index=0, type, n=0, last=-1) =
	(n>last) ? n :
	(get_value(list[n],type)==value) ?
		(index==0) ? n
		:	find_first_intern_type (list, value, index-1, type, n+1, last)
	:		find_first_intern_type (list, value, index,   type, n+1, last)
;
//
// sucht nach dem ersten Auftreten eines Wertes und gibt die Position des Treffers aus einer Liste heraus
function find_first_once (list, value, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	find_first_once_intern (list, value, type, Range[0], Range[1])
;
function find_first_once_intern (list, value, type=0, n=0, last=-1) =
	 type   == 0 ? find_first_once_intern_direct   (list, value         , n, last)
	:type[0]>= 0 ? find_first_once_intern_list     (list, value, type[0], n, last)
	:type[0]==-1 ? find_first_once_intern_function (list, value, type[1], n, last)
	:              find_first_once_intern_type     (list, value, type   , n, last)
;
function find_first_once_intern_direct   (list, value, n=0, last=-1) =
	(n>last) || (list[n]                ==value) ? n :
	find_first_once_intern_direct        (list, value, n+1, last)
;
function find_first_once_intern_list     (list, value, position, n=0, last=-1) =
	(n>last) || (list[n][position]      ==value) ? n :
	find_first_once_intern_list          (list, value, position, n+1, last)
;
function find_first_once_intern_function (list, value, fn, n=0, last=-1) =
	(n>last) || (fn(list[n])            ==value) ? n :
	find_first_once_intern_function      (list, value, fn, n+1, last)
;
function find_first_once_intern_type     (list, value, type, n=0, last=-1) =
	(n>last) || (get_value(list[n],type)==value) ? n :
	find_first_once_intern_type          (list, value, type, n+1, last)
;

// sucht nach einem Wert und gibt die Position des Treffers aus einer Liste heraus
// Die Liste wird vom Ende aus rückwärts durchsucht
// Wurde der Wert nicht gefunden, wird die Position vor dem ersten Element zurückgegeben
// Argumente:
//   list    -Liste
//   value   -gesuchter Wert
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste vom Ende aus gefundene Schlüssel genommen (index=0)
function find_last (list, value, index=0, type=0, begin, last, count, range) =
	list==undef ? -1 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	index==0 ? find_last_once_intern (list, value, type, Range[1], Range[0]) :
	//
	 type   == 0 ? find_last_intern_direct   (list, value, index         , Range[1], Range[0])
	:type[0]>= 0 ? find_last_intern_list     (list, value, index, type[0], Range[1], Range[0])
	:type[0]==-1 ? find_last_intern_function (list, value, index, type[1], Range[1], Range[0])
	:              find_last_intern_type     (list, value, index, type   , Range[1], Range[0])
;
function find_last_intern_direct (list, value, index=0, n=-2, first=0) =
	(n<first) ? n
	:(list[n]==value) ?
		(index==0) ? n
		:	find_last_intern_direct (list, value, index-1, n-1, first)
	:		find_last_intern_direct (list, value, index,   n-1, first)
;
function find_last_intern_list (list, value, index=0, position=0, n=-2, first=0) =
	(n<first) ? n
	:(list[n][position]==value) ?
		(index==0) ? n
		:	find_last_intern_list (list, value, index-1, position, n-1, first)
	:		find_last_intern_list (list, value, index,   position, n-1, first)
;
function find_last_intern_function (list, value, index=0, fn, n=-2, first=0) =
	(n<first) ? n
	:(fn(list[n])==value) ?
		(index==0) ? n
		:	find_last_intern_function (list, value, index-1, fn, n-1, first)
	:		find_last_intern_function (list, value, index,   fn, n-1, first)
;
function find_last_intern_type (list, value, index=0, type, n=-2, first=0) =
	(n<first) ? n
	:(get_value(list[n],type)==value) ?
		(index==0) ? n
		:	find_last_intern_type (list, value, index-1, type, n-1, first)
	:		find_last_intern_type (list, value, index,   type, n-1, first)
;
//
// sucht rückwärts nach dem ersten Auftreten eines Wertes und gibt die Position des Treffers aus einer Liste heraus
function find_last_once (list, value, type=0, begin, last, count, range) =
	list==undef ? -1 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	find_last_once_intern (list, value, type=0, Range[1], Range[0])
;
function find_last_once_intern (list, value, type=0, n=-1, first=0) =
	 type   == 0 ? find_last_once_intern_direct   (list, value         , n, first)
	:type[0]>= 0 ? find_last_once_intern_list     (list, value, type[0], n, first)
	:type[0]==-1 ? find_last_once_intern_function (list, value, type[1], n, first)
	:              find_last_once_intern_type     (list, value, type   , n, first)
;
function find_last_once_intern_direct   (list, value, n=-2, first=0) =
	(n<first) || (list[n]                ==value) ? n :
	find_last_once_intern_direct        (list, value, n-1, first)
;
function find_last_once_intern_list     (list, value, position, n=-2, first=0) =
	(n<first) || (list[n][position]      ==value) ? n :
	find_last_once_intern_list          (list, value, position, n-1, first)
;
function find_last_once_intern_function (list, value, fn, n=-2, first=0) =
	(n<first) || (fn(list[n])            ==value) ? n :
	find_last_once_intern_function      (list, value, fn, n-1, first)
;
function find_last_once_intern_type     (list, value, type, n=-2, first=0) =
	(n<first) || (get_value(list[n],type)==value) ? n :
	find_last_once_intern_type          (list, value, type, n-1, first)
;

// Testet 2 Listen nach Gleichheit und gibt den ersten Treffer bei 'list1', der nicht gleich ist.
// Die Rückgabe enthält die Position des Treffers beider Listen als Liste [pos list1, pos list2].
// Vergleicht die Daten direkt mit dem Operator == oder mit Funktion 'f', wenn angegeben
function mismatch (list1, list2, begin1=0, begin2=0, count=undef, type=0, f=undef) =
	list1==undef || list2==undef ? 0 :
	let (
		Range1 = parameter_range_safe (list1, begin1, undef, count, undef),
		Range2 = parameter_range_safe (list2, begin2, undef, count, undef),
		Begin1 = Range1[0],
		Begin2 = Range2[0],
		Count1 = Range1[1] - Range1[0] + 1,
		Count2 = Range2[1] - Range2[0] + 1,
		Count  = min (Count1, Count2),
		result =
			f==undef ?
				 type   == 0 ? mismatch_count_intern_direct   (list1, list2,          Begin1, Begin2, Count)
				:type[0]>= 0 ? mismatch_count_intern_list     (list1, list2, type[0], Begin1, Begin2, Count)
				:type[0]==-1 ? mismatch_count_intern_function (list1, list2, type[1], Begin1, Begin2, Count)
				:              mismatch_count_intern_type     (list1, list2, type   , Begin1, Begin2, Count)
			:
				 type   == 0 ? mismatch_count_intern_f_direct   (list1, list2, f,          Begin1, Begin2, Count)
				:type[0]>= 0 ? mismatch_count_intern_f_list     (list1, list2, f, type[0], Begin1, Begin2, Count)
				:type[0]==-1 ? mismatch_count_intern_f_function (list1, list2, f, type[1], Begin1, Begin2, Count)
				:              mismatch_count_intern_f_type     (list1, list2, f, type   , Begin1, Begin2, Count)
	)
	[Begin1+result, Begin2+result]
;
//
function mismatch_count_intern_direct (list1, list2, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	(list1[begin1+i] != list2[begin2+i]) ? i :
	mismatch_count_intern_direct (list1, list2, begin1, begin2, count, i+1)
;
function mismatch_count_intern_list (list1, list2, position=0, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	(list1[begin1+i][position] != list2[begin2+i][position]) ? i :
	mismatch_count_intern_list (list1, list2, position, begin1, begin2, count, i+1)
;
function mismatch_count_intern_function (list1, list2, fn, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	(fn(list1[begin1+i]) != fn(list2[begin2+i])) ? i :
	mismatch_count_intern_function (list1, list2, fn, begin1, begin2, count, i+1)
;
function mismatch_count_intern_type (list1, list2, type, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	(get_value(list1[begin1+i],type) != get_value(list2[begin2+i],type)) ? i :
	mismatch_count_intern_type (list1, list2, type, begin1, begin2, count, i+1)
;
//
function mismatch_count_intern_f_direct (list1, list2, f, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	!f (list1[begin1+i], list2[begin2+i]) ? i :
	mismatch_count_intern_f_direct (list1, list2, f, begin1, begin2, count, i+1)
;
function mismatch_count_intern_f_list (list1, list2, f, position=0, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	!f (list1[begin1+i][position], list2[begin2+i][position]) ? i :
	mismatch_count_intern_f_list (list1, list2, f, position, begin1, begin2, count, i+1)
;
function mismatch_count_intern_f_function (list1, list2, f, fn, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	!f (fn(list1[begin1+i]), fn(list2[begin2+i])) ? i :
	mismatch_count_intern_f_function (list1, list2, f, fn, begin1, begin2, count, i+1)
;
function mismatch_count_intern_f_type (list1, list2, f, type, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	!f (get_value(list1[begin1+i],type), get_value(list2[begin2+i],type)) ? i :
	mismatch_count_intern_f_type (list1, list2, f, type, begin1, begin2, count, i+1)
;

// Testet 2 Listen nach Gleichheit und gibt alle Treffer, die nicht gleich sind als Liste aus.
// Die Werte in der Rückgabeliste enthält die Positionen der Treffer beider Listen als Liste [pos list1, pos list2].
// Vergleicht die Daten direkt mit dem Operator == oder mit Funktion 'f', wenn angegeben
function mismatch_list (list1, list2, begin1=0, begin2=0, count=undef, type=0, f=undef) =
	let (
		Range1 = parameter_range_safe (list1, begin1, undef, count, undef),
		Range2 = parameter_range_safe (list2, begin2, undef, count, undef),
		Begin1 = Range1[0],
		Begin2 = Range2[0],
		Count1 = Range1[1] - Range1[0] + 1,
		Count2 = Range2[1] - Range2[0] + 1,
		Count     = min (Count1, Count2),
		Count_max = max (Count1, Count2)
	)
	[ each
	f==undef ?
		 type   == 0                   ? [for(i=[0:1:Count-1]) if (list1[Begin1+i]                 != list2[Begin2+i]                ) [Begin1+i, Begin2+i] ]
		:type[0]>= 0                   ? [for(i=[0:1:Count-1]) if (list1[Begin1+i][type[0]]        != list2[Begin2+i][type[0]]       ) [Begin1+i, Begin2+i] ]
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[0:1:Count-1]) if (fn(list1[Begin1+i])             != fn(list2[Begin2+i])            ) [Begin1+i, Begin2+i] ]
		:                                [for(i=[0:1:Count-1]) if (get_value(list1[Begin1+i],type) != get_value(list1[Begin1+i],type)) [Begin1+i, Begin2+i] ]
	:
		 type   == 0                   ? [for(i=[0:1:Count-1]) if (f( list1[Begin1+i]                , list2[Begin2+i]                ) !=true) [Begin1+i, Begin2+i] ]
		:type[0]>= 0                   ? [for(i=[0:1:Count-1]) if (f( list1[Begin1+i][type[0]]       , list2[Begin2+i][type[0]]       ) !=true) [Begin1+i, Begin2+i] ]
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[0:1:Count-1]) if (f( fn(list1[Begin1+i])            , fn(list2[Begin2+i])            ) !=true) [Begin1+i, Begin2+i] ]
		:                                [for(i=[0:1:Count-1]) if (f( get_value(list1[Begin1+i],type), get_value(list1[Begin1+i],type)) !=true) [Begin1+i, Begin2+i] ]
	, each Count==Count_max ? [] : [for(i=[Count:1:Count_max-1]) [Begin1+i, Begin2+i] ]
	]
;

// Zählt das Vorkommen eines Wertes in der Liste
// Argumente:
//   list    -Liste
//   value   -gesuchter Wert
// Optionale Angabe des Bereichs:
//     begin = erstes Element aus der Liste
//     last  = letztes Element
// oder
//     range = [begin, last]
// Kodierung wie in python
function count        (list, value, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	count_intern      (list, value, type, Range[0], Range[1])
;
// Zähle alles durch von Position n nach k
function count_intern (list, value, type=0, n=0, k=-1) =
	n>k ? 0 :
	 type   == 0                   ? len([for(i=[n:1:k]) if (list[i]                ==value) 0])
	:type[0]>= 0                   ? len([for(i=[n:1:k]) if (list[i][type[0]]       ==value) 0])
	:type[0]==-1 ? let( fn=type[1] ) len([for(i=[n:1:k]) if (fn(list[i])            ==value) 0])
	:                                len([for(i=[n:1:k]) if (get_value(list[i],type)==value) 0])
;
function count_intern_old (list, value, type=0, n=0, k=-1, count=0) =
	 type   == 0 ? count_intern_direct   (list, value,          n, k)
	:type[0]>= 0 ? count_intern_list     (list, value, type[0], n, k)
	:type[0]==-1 ? count_intern_function (list, value, type[1], n, k)
	:              count_intern_type     (list, value, type,    n, k)
;
function count_intern_direct (list, value, n=0, k=-1, count=0) =
	n>k ? count :
	count_intern_direct (list, value
		, n+1, k,
		, count + ( list[n]==value ? 1 : 0 )
	)
;
function count_intern_list (list, value, position=0, n=0, k=-1, count=0) =
	n>k ? count :
	count_intern_list (list, value, position
		, n+1, k,
		, count + ( list[n][position]==value ? 1 : 0 )
	)
;
function count_intern_function (list, value, fn, n=0, k=-1, count=0) =
	n>k ? count :
	count_intern_function (list, value, fn
		, n+1, k,
		, count + ( fn(list[n])==value ? 1 : 0 )
	)
;
function count_intern_type (list, value, type, n=0, k=-1, count=0) =
	n>k ? count :
	count_intern_type (list, value, type
		, n+1, k,
		, count + ( get_value(list[n],type)==value ? 1 : 0 )
	)
;

// Entfernt alle Duplikate aus der Liste
function remove_duplicate (list, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0 ? remove_duplicate_intern_direct   (list)
	:type[0]>= 0 ? remove_duplicate_intern_list     (list, type[0])
	:type[0]==-1 ? remove_duplicate_intern_function (list, type[1])
	:              remove_duplicate_intern_type     (list, type)
;
function remove_duplicate_intern_direct (list, i=0, new=[], last=[]) =
	i==len(list) ? concat(new,last):
	// test value is in 'new'
	((last!=[] && last[0]==list[i]) || (len([for (e=new) if (e==list[i]) 0]) != 0) ) ?
		remove_duplicate_intern_direct (list, i+1, new, last)
	:	remove_duplicate_intern_direct (list, i+1, concat(new,last), [list[i]])
;
function remove_duplicate_intern_list (list, position=0, i=0, new=[], last=[]) =
	i==len(list) ? concat(new,last):
	let( v = list[i][position] )
	// test value is in 'new'
	((last!=[] && last[0][position]==v) || (len([for (e=new) if (e[position]==v) 0]) != 0) ) ?
		remove_duplicate_intern_list (list, position, i+1, new, last)
	:	remove_duplicate_intern_list (list, position, i+1, concat(new,last), [list[i]])
;
function remove_duplicate_intern_function (list, fn, i=0, new=[], values=[], last=[]) =
	i==len(list) ? new :
	let( v = fn(list[i]) )
	// test value is in 'new'
	((last!=[] && last[0]==v) || (len([for (e=values) if (e==v) 0]) != 0) ) ?
		remove_duplicate_intern_function (list, fn, i+1, new, values, last)
	:	remove_duplicate_intern_function (list, fn, i+1, concat(new,[list[i]]), concat(values,last), [v])
;
function remove_duplicate_intern_type (list, type, i=0, new=[], values=[], last=[]) =
	i==len(list) ? new :
	let( v = get_value(list[i],type) )
	// test value is in 'new'
	((last!=[] && last[0]==v) || (len([for (e=values) if (e==v) 0]) != 0) ) ?
		remove_duplicate_intern_type (list, type, i+1, new, values, last)
	:	remove_duplicate_intern_type (list, type, i+1, concat(new,[list[i]]), concat(values,last), [v])
;


// Entfernt alle Vorkommen eines Wertes
function remove_value (list, value, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0                   ? [ for (e=list) if (e                !=value) e ]
	:type[0]>= 0                   ? [ for (e=list) if (e[type[0]]       !=value) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (fn(e)            !=value) e ]
	:                                [ for (e=list) if (get_value(e,type)!=value) e ]
;

// Entfernt alle Vorkommen von Werten aus einer Liste
function remove_all_values (list, value_list, type=0) =
	list==undef || len(list)==0 ? list :
	value_list==undef || len(value_list)==0 ? list :
	 type   == 0 ?                   [ for (e=list)                             if ( len([for(value=value_list) if (e ==value) 0]) == 0 ) e ]
	:type[0]>= 0 ?                   [ for (e=list) let(ev = e[type[0]])        if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) let(ev = fn(e))             if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e ]
	:                                [ for (e=list) let(ev = get_value(e,type)) if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e ]
;

// Ersetzt alle Vorkommen eines Wertes durch einen anderen Wert
function replace_value (list, value, new, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0 ?                   [ for (e=list) if (e                !=value) e else new ]
	:type[0]>= 0 ?                   [ for (e=list) if (e[type[0]]       !=value) e else new ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (fn(e)            !=value) e else new ]
	:                                [ for (e=list) if (get_value(e,type)!=value) e else new ]
;

// Ersetzt alle Vorkommen von Werten aus einer Liste durch einen anderen Wert
function replace_all_values (list, value_list, new, type=0) =
	list==undef || len(list)==0 ? list :
	value_list==undef || len(value_list)==0 ? list :
	 type   == 0 ?                   [ for (e=list)                             if ( len([for(value=value_list) if (e ==value) 0]) == 0 ) e else new ]
	:type[0]>= 0 ?                   [ for (e=list) let(ev = e[type[0]])        if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e else new ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) let(ev = fn(e))             if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e else new ]
	:                                [ for (e=list) let(ev = get_value(e,type)) if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e else new ]
;

// Entfernt alle aufeinanderfolgenden Duplikate
function unique (list, type=0, f=undef) =
	list==undef || len(list)<=1 ? list :
	let( size = len(list) )
	f==undef ?
		 type   == 0 ?
			[ each
				[ for (i=0  ,v=list[i]                ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i]                ,is_unique=!(v==last),last=is_unique?v:last )
				if (is_unique) v ]
			, each (list[size-2]                ==list[size-1]                ) ? [] : [list[size-1]]
			]
		:type[0]>= 0 ?
			[ each
				[ for (i=0  ,v=list[i][type[0]]       ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i][type[0]]       ,is_unique=!(v==last),last=is_unique?v:last )
				if (is_unique) list[i] ]
			, each (list[size-2][type[0]]       ==list[size-1][type[0]]       ) ? [] : [list[size-1]]
			]
		:type[0]==-1 ? let( fn=type[1] )
			[ each
				[ for (i=0  ,v=fn(list[i])            ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=fn(list[i])            ,is_unique=!(v==last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each (fn(list[size-2])            ==fn(list[size-1])            ) ? [] : [list[size-1]]
			]
		:
			[ each
				[ for (i=0  ,v=get_value(list[i],type),is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=get_value(list[i],type),is_unique=!(v==last),last=is_unique?v:last )
				if (is_unique) list[i] ]
			, each (get_value(list[size-2],type)==get_value(list[size-1],type)) ? [] : [list[size-1]]
			]
	:
		 type   == 0 ?
			[ each
				[ for (i=0  ,v=list[i]                ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i]                ,is_unique=!f(v,last),last=is_unique?v:last )
				if (is_unique) v ]
			, each f(list[size-2]                ,list[size-1]                ) ? [] : [list[size-1]]
			]
		:type[0]>= 0 ?
			[ each
				[ for (i=0  ,v=list[i][type[0]]       ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i][type[0]]       ,is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f(list[size-2][type[0]]       ,list[size-1][type[0]]       ) ? [] : [list[size-1]]
			]
		:type[0]==-1 ? let( fn=type[1] )
			[ each
				[ for (i=0  ,v=fn(list[i])            ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=fn(list[i])            ,is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f(fn(list[size-2])            ,fn(list[size-1])            ) ? [] : [list[size-1]]
			]
		:
			[ each
				[ for (i=0  ,v=get_value(list[i],type),is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=get_value(list[i],type),is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f(get_value(list[size-2],type),get_value(list[size-1],type)) ? [] : [list[size-1]]
			]
;

