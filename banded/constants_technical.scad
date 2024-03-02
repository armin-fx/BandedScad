// Copyright (c) 2024 Armin Frenzel
// License: LGPL-2.1-or-later
//
// definiert technische Konstanten


// Papiergröße nach ISO 216
// Format: [kleinste Seite, größte Seite]
//
function iso_216 (format, serie, number) =
	let (
		Format = format==undef ? [serie, number] :
			[ format[0]
			, format[2]==undef
				?                                    (ord(format[1]) - ord("0"))
				: 10 * (ord(format[1]) - ord("0")) + (ord(format[2]) - ord("0"))
			]
		,Serie  = Format[0]
		,Number = Format[1]
	)
	(Number<0 || Number>10) ? undef :
	 Serie=="A" || Serie=="a" ?
		let( sides = [1189,  841, 594, 420, 297, 210, 148, 105, 74, 52, 37, 26] )
		[sides[Number+1], sides[Number]]
	:Serie=="B" || Serie=="b" ?
		let( sides = [1414, 1000, 707, 500, 353, 250, 176, 125, 88, 62, 44, 31] )
		[sides[Number+1], sides[Number]]
	:Serie=="C" || Serie=="c" ?
		let( sides = [1297,  917, 648, 458, 324, 229, 162, 114, 81, 57, 40, 28] )
		[sides[Number+1], sides[Number]]
	: undef
;
//
// A Serie:
ISO_A0  = iso_216 ("A0");
ISO_A1  = iso_216 ("A1");
ISO_A2  = iso_216 ("A2");
ISO_A3  = iso_216 ("A3");
ISO_A4  = iso_216 ("A4");
ISO_A5  = iso_216 ("A5");
ISO_A6  = iso_216 ("A6");
ISO_A7  = iso_216 ("A7");
ISO_A8  = iso_216 ("A8");
ISO_A9  = iso_216 ("A9");
ISO_A10 = iso_216 ("A10");
// B Serie:
ISO_B0  = iso_216 ("B0");
ISO_B1  = iso_216 ("B1");
ISO_B2  = iso_216 ("B2");
ISO_B3  = iso_216 ("B3");
ISO_B4  = iso_216 ("B4");
ISO_B5  = iso_216 ("B5");
ISO_B6  = iso_216 ("B6");
ISO_B7  = iso_216 ("B7");
ISO_B8  = iso_216 ("B8");
ISO_B9  = iso_216 ("B9");
ISO_B10 = iso_216 ("B10");
// C Serie:
ISO_C0  = iso_216 ("C0");
ISO_C1  = iso_216 ("C1");
ISO_C2  = iso_216 ("C2");
ISO_C3  = iso_216 ("C3");
ISO_C4  = iso_216 ("C4");
ISO_C5  = iso_216 ("C5");
ISO_C6  = iso_216 ("C6");
ISO_C7  = iso_216 ("C7");
ISO_C8  = iso_216 ("C8");
ISO_C9  = iso_216 ("C9");
ISO_C10 = iso_216 ("C10");

// Briefumschlaggröße nach ISO 269
// Format: [größte Seite, kleinste Seite]
//
function iso_269 (format) =
	 format=="DL"    || format=="dl"    ? [220, 110]
	:format=="C7"    || format=="c7"    ? [ 81, 114]
	:format=="C7/C6" || format=="c7/c6" ? [ 81, 162]
	:format=="C6"    || format=="c6"    ? [114, 162]
	:format=="C6/C5" || format=="c6/c5" ? [114, 229]
	:format=="C5"    || format=="c5"    ? [162, 229]
	:format=="C4"    || format=="c4"    ? [229, 324]
	:format=="C3"    || format=="c3"    ? [324, 458]
	:format=="B6"    || format=="b6"    ? [125, 176]
	:format=="B5"    || format=="b5"    ? [176, 250]
	:format=="B4"    || format=="b4"    ? [250, 353]
	:format=="E4"    || format=="e4"    ? [280, 400]
	:undef
;
//
envelope_ISO_DL   = iso_269 ("DL");
envelope_ISO_C7   = iso_269 ("C7");
envelope_ISO_C7C6 = iso_269 ("C7/C6");
envelope_ISO_C6   = iso_269 ("C6");
envelope_ISO_C6C5 = iso_269 ("C6/C5");
envelope_ISO_C5   = iso_269 ("C5");
envelope_ISO_C4   = iso_269 ("C4");
envelope_ISO_C3   = iso_269 ("C3");
envelope_ISO_B6   = iso_269 ("B6");
envelope_ISO_B5   = iso_269 ("B5");
envelope_ISO_B4   = iso_269 ("B4");
envelope_ISO_E4   = iso_269 ("E4");

