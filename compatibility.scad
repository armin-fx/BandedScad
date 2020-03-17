// defines functions and modules to keep compatibility
// with older versions than 2019.05
// and newer than 2015.03

// emulate new testing functions
function is_undef  (value) = (undef==value);
function is_bool   (value) = (value==true || value==false);
function is_num    (value) = (concat(value)!=value && value+0!=undef);
function is_list   (value) = (concat(value)==value);
function is_string (value) = (str(value)==value);
