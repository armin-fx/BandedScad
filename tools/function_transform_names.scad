// function_transform_names.scad
//
// Wandelt die Namen der Funktionen zum Transformieren von Punktlisten
// in Namen um wie die entsprechenden Module ohne die Endung _list

function translate  (list, v)    = translate_list (list, v);
function rotate     (list, a, v) = rotate_list    (list, a, v);
function mirror     (list, v)    = mirror_list    (list, v);
function scale      (list, v)    = scale_list     (list, v);
function projection (list, cut, plane) = projection_list (list, cut, plane);
//
function rotate_backwards              (list, a, v)    = rotate_backwards_list             (list, a, v);
function rotate_at                     (list, a, p, v) = rotate_at_list                    (list, a, p, v);
function rotate_backwards_at           (list, a, p, v) = rotate_backwards_at_list          (list, a, p, v);
function rotate_to_vector              (list, v, a)    = rotate_to_vector_list             (list, v, a);
function rotate_backwards_to_vector    (list, v, a)    = rotate_backwards_to_vector_list   (list, v, a);
function rotate_to_vector_at           (list, v, p, a) = rotate_to_vector_at_list          (list, v, p, a);
function rotate_backwards_to_vector_at (list, v, p, a) = rotate_backwards_to_vector_at_list(list, v, p, a);
//
function rotate_x           (list, a) = rotate_x_list           (list, a);
function rotate_y           (list, a) = rotate_y_list           (list, a);
function rotate_z           (list, a) = rotate_z_list           (list, a);
function rotate_backwards_x (list, a) = rotate_backwards_x_list (list, a);
function rotate_backwards_y (list, a) = rotate_backwards_y_list (list, a);
function rotate_backwards_z (list, a) = rotate_backwards_z_list (list, a);
function rotate_at_x           (list, a, p) = rotate_at_x_list           (list, a, p);
function rotate_at_y           (list, a, p) = rotate_at_y_list           (list, a, p);
function rotate_at_z           (list, a, p) = rotate_at_z_list           (list, a, p);
function rotate_backwards_at_x (list, a, p) = rotate_backwards_at_x_list (list, a, p);
function rotate_backwards_at_y (list, a, p) = rotate_backwards_at_y_list (list, a, p);
function rotate_backwards_at_z (list, a, p) = rotate_backwards_at_z_list (list, a, p);
//
function translate_x  (list, l) = translate_x_list  (list, l);
function translate_y  (list, l) = translate_y_list  (list, l);
function translate_z  (list, l) = translate_z_list  (list, l);
function translate_xy (list, t) = translate_xy_list (list, t);
//
function mirror_x (list) = mirror_x_list (list);
function mirror_y (list) = mirror_y_list (list);
function mirror_z (list) = mirror_z_list (list);
function mirror_at_x (list, p) = mirror_at_x_list (list, p);
function mirror_at_y (list, p) = mirror_at_y_list (list, p);
function mirror_at_z (list, p) = mirror_at_z_list (list, p);
//
function scale_x (list, f) = scale_x_list (list, f);
function scale_y (list, f) = scale_y_list (list, f);
function scale_z (list, f) = scale_z_list (list, f);

