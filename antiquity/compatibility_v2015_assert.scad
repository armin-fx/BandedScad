// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines module assert() which are new in OpenSCAD version 2019.05
// to keep compatibility with OpenSCAD version 2015.03
//
// !!! It will make an error if OpenSCAD version has buildin assert() !!!

// Assert evaluates a logical expression,
// but it can not stop the process like new real assert in OpenSCAD
module assert (condition, message)
{
	if (! condition)
	{
		tree      = get_parents();
		str_begin = str("<font color=\"red\"><br>\n","ERROR: Assertion failed");
		str_tree  = tree=="" ? "" : str(" in parent modules \'",tree,"\'");
		str_end   = str("        </font><br>");
		if (message==undef) echo (str(
			str_begin,
			str_tree,
			str_end));
		else echo (str(
			str_begin, ": \"",
			message,
			"\"",
			str_tree,
			str_end));
	}
	function get_parents (text="", n=$parent_modules-1) = 
		n<=0 ? text :
		text=="" ?
			get_parents( str(parent_module(n)), n-1)
		:	get_parents( str(text,"->",parent_module(n) ) , n-1)
	;
}
