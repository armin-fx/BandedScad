// function_transform_names.scad
//
// Wandelt die Namen der Funktionen zum Transformieren von Punktlisten
// in Namen um wie die entsprechenden Module ohne die Endung _list

function translate (list, v)    = translate_list (list, v);
function rotate    (list, a, v) = rotate_list    (list, a, v);
//
function rotate_backwards              (list, a, v)                      = rotate_backwards_list             (list, a, v);
function rotate_at                     (list, a, p=[0,0,0], v)           = rotate_at_list                    (list, a, p, v);
function rotate_backwards_at           (list, a, p=[0,0,0], v)           = rotate_backwards_at_list          (list, a, p, v);
function rotate_to_vector              (list, v=[0,0,1], a=0)            = rotate_to_vector_list             (list, v, a);
function rotate_backwards_to_vector    (list, v=[0,0,1], a=0)            = rotate_backwards_to_vector_list   (list, v, a);
function rotate_to_vector_at           (list, v=[0,0,1], p=[0,0,0], a=0) = rotate_to_vector_at_list          (list, v, p, a);
function rotate_backwards_to_vector_at (list, v=[0,0,1], p=[0,0,0], a=0) = rotate_backwards_to_vector_at_list(list, v, p, a);
//
function rotate_x           (list, a) = rotate_x_list           (list, a);
function rotate_y           (list, a) = rotate_y_list           (list, a);
function rotate_z           (list, a) = rotate_z_list           (list, a);
function rotate_backwards_x (list, a) = rotate_backwards_x_list (list, a);
function rotate_backwards_y (list, a) = rotate_backwards_y_list (list, a);
function rotate_backwards_z (list, a) = rotate_backwards_z_list (list, a);
function rotate_at_x           (list, a, p=[0,0,0]) = rotate_at_x_list           (list, a, p);
function rotate_at_y           (list, a, p=[0,0,0]) = rotate_at_y_list           (list, a, p);
function rotate_at_z           (list, a, p=[0,0,0]) = rotate_at_z_list           (list, a, p);
function rotate_backwards_at_x (list, a, p=[0,0,0]) = rotate_backwards_at_x_list (list, a, p);
function rotate_backwards_at_y (list, a, p=[0,0,0]) = rotate_backwards_at_y_list (list, a, p);
function rotate_backwards_at_z (list, a, p=[0,0,0]) = rotate_backwards_at_z_list (list, a, p);
//
// verschiebt in der jeweiligen Achse wie die Hauptfunktion
function translate_x  (list, l) = translate_x_list  (list, l);
function translate_y  (list, l) = translate_y_list  (list, l);
function translate_z  (list, l) = translate_z_list  (list, l);
function translate_xy (list, t) = translate_xy_list (list, t);
