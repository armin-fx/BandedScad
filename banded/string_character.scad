// Copyright (c) 2023 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum prüfen und umwandeln
// von einzelnen Zeichen in Strings


// Check if one character at position 'pos' is a numeric value
function is_digit (txt, pos=0) =
	txt[pos]>="0" && txt[pos]<="9"
;

// Check if one character at position 'pos' is alphabetic
function is_alpha (txt, pos=0) =
	   (txt[pos]>="a" && txt[pos]<="z")
	|| (txt[pos]>="A" && txt[pos]<="Z")
;

// Check if character is alphanumeric
function is_alnum (txt, pos=0) =
	   (txt[pos]>="a" && txt[pos]<="z")
	|| (txt[pos]>="A" && txt[pos]<="Z")
	|| (txt[pos]>="0" && txt[pos]<="9")
;

// Check if character is hexadecimal digit
function is_xdigit (txt, pos=0) =
	   (txt[pos]>="0" && txt[pos]<="9")
	|| (txt[pos]>="a" && txt[pos]<="f")
	|| (txt[pos]>="A" && txt[pos]<="F")
;

// Check if character is lowercase letter
function is_lower (txt, pos=0) =
	   (txt[pos]>="a" && txt[pos]<="z")
;

// Check if character is uppercase letter
function is_upper (txt, pos=0) =
	   (txt[pos]>="A" && txt[pos]<="Z")
;

// Check if character is a white-space
function is_space (txt, pos=0) =
	   txt[pos]==" "
	|| txt[pos]=="\t"
	|| txt[pos]=="\n"
	|| txt[pos]=="\r"
	|| txt[pos]=="\v"
	|| txt[pos]=="\f"
;

// Check if character is blanc
function is_blanc (txt, pos=0) =
	   txt[pos]==" "
	|| txt[pos]=="\t"
;

// Check if character is a punctuation character
function is_punct (txt, pos=0) =
	// is_graph
	( txt[pos]>" " && txt[pos]!="" )
	&&
	// ! is_alnum
	! (
		   (txt[pos]>="a" && txt[pos]<="z")
		|| (txt[pos]>="A" && txt[pos]<="Z")
		|| (txt[pos]>="0" && txt[pos]<="9")
	)
;

// Check if character is a control character
function is_cntrl (txt, pos=0) =
	txt[pos]<" " || txt[pos]==""
;

// Check if character is printable
function is_print (txt, pos=0) =
	txt[pos]>=" " && txt[pos]!=""
;

// Check if character has graphical representation
function is_graph (txt, pos=0) =
	txt[pos]>" " && txt[pos]!=""
;


// Convert uppercase letter to lowercase
function to_lower (txt, pos=0) =
	(txt[pos]>="A" && txt[pos]<="Z")
	?	chr( ord(txt[pos]) + 32 )
	:	txt[pos]
;

// Convert lowercase letter to uppercase
function to_upper (txt, pos=0) =
	(txt[pos]>="a" && txt[pos]<="z")
	?	chr( ord(txt[pos]) - 32 )
	:	txt[pos]
;
