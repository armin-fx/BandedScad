// Copyright (c) 2024 Armin Frenzel
// License: LGPL-2.1-or-later
//
// definiert technische Konstanten


// Papiergröße nach ISO 216
// Format: [kleinste Seite, größte Seite]
//
function iso_216 (serie="A", number=0) =
	(number<0 || number>10) ? undef :
	 serie=="A" ?
		let( sides = [1189,  841, 594, 420, 297, 210, 148, 105, 74, 52, 37, 26] )
		[sides[number+1], sides[number]]
	:serie=="B" ?
		let( sides = [1414, 1000, 707, 500, 353, 250, 176, 125, 88, 62, 44, 31] )
		[sides[number+1], sides[number]]
	:serie=="C" ?
		let( sides = [1297,  917, 648, 458, 324, 229, 162, 114, 81, 57, 40, 28] )
		[sides[number+1], sides[number]]
	: undef
;
//
// A Serie:
ISO_A0  = iso_216 ("A", 0);
ISO_A1  = iso_216 ("A", 1);
ISO_A2  = iso_216 ("A", 2);
ISO_A3  = iso_216 ("A", 3);
ISO_A4  = iso_216 ("A", 4);
ISO_A5  = iso_216 ("A", 5);
ISO_A6  = iso_216 ("A", 6);
ISO_A7  = iso_216 ("A", 7);
ISO_A8  = iso_216 ("A", 8);
ISO_A9  = iso_216 ("A", 9);
ISO_A10 = iso_216 ("A",10);
// B Serie:
ISO_B0  = iso_216 ("B", 0);
ISO_B1  = iso_216 ("B", 1);
ISO_B2  = iso_216 ("B", 2);
ISO_B3  = iso_216 ("B", 3);
ISO_B4  = iso_216 ("B", 4);
ISO_B5  = iso_216 ("B", 5);
ISO_B6  = iso_216 ("B", 6);
ISO_B7  = iso_216 ("B", 7);
ISO_B8  = iso_216 ("B", 8);
ISO_B9  = iso_216 ("B", 9);
ISO_B10 = iso_216 ("B",10);
// C Serie:
ISO_C0  = iso_216 ("C", 0);
ISO_C1  = iso_216 ("C", 1);
ISO_C2  = iso_216 ("C", 2);
ISO_C3  = iso_216 ("C", 3);
ISO_C4  = iso_216 ("C", 4);
ISO_C5  = iso_216 ("C", 5);
ISO_C6  = iso_216 ("C", 6);
ISO_C7  = iso_216 ("C", 7);
ISO_C8  = iso_216 ("C", 8);
ISO_C9  = iso_216 ("C", 9);
ISO_C10 = iso_216 ("C",10);

