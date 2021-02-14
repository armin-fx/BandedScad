// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines module assert() to keep compatibility
// with older versions than 2019.05
// and newer than or equal 2015.03
//
// !!! It will make an error if OpenScad version has buildin assert() !!!

// Assert evaluates a logical expression,
// but it can not stop the process like new real assert in OpenScad
module assert (condition, string)
{
	if (! condition)
	{
		tree      = get_parents();
		str_begin = str("<font color=\"red\"><br>\n","ERROR: Assertion failed");
		str_tree  = tree=="" ? "" : str(" in parent modules \'",tree,"\'");
		str_end   = str("        </font><br>");
		if (string==undef) echo (str(
			str_begin,
			str_tree,
			str_end));
		else echo (str(
			str_begin, " \"",
			string,
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
