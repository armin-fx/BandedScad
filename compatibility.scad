// defines functions and modules to keep compatibility
// with older versions than 2019.05
// and newer than 2015.03

// emulate new testing functions
function is_undef  (value) = (undef==value);
function is_bool   (value) = (value==true || value==false);
function is_num    (value) = (concat(value)!=value && value+0!=undef && value==value);
function is_list   (value) = (concat(value)==value);
function is_string (value) = (str(value)==value);

// Convert the first character of the given string to a Unicode code point.
function ord (string) =
	!is_string(string)    ? undef :
	!is_string(string[0]) ? undef :
	ord_intern_range(string)
;
function ord_intern_range (string, under=30, upper=128) =
	string[0]>chr(upper) ? ord_intern_range(string, upper, upper*4) :
	string[0]<chr(under) ? ord_intern_range(string, 0    , under)   :
	ord_intern_search(string, under, upper)
;
function ord_intern_search (string, under=0, upper=255) =
	let( middle=floor((under+upper)/2) )
	string[0]==chr(middle) ? middle :
	string[0]< chr(middle) ?
		ord_intern_search(string, under, middle-1) :
		ord_intern_search(string, middle+1, upper)
;
