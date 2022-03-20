Overview of scad files
======================

[<-- table of contents](contents.md)

`banded.scad`\
` `|\
` `+--> [`banded/constants.scad`](constants.md "Define some constants")\
` `| . . . +--> `banded/constants_helper.scad`\
` `|\
` `+--> [`banded/math.scad`](math.md "Math functions")\
` `| . . . +--> [`banded/math_common.scad`](math.md#various-math-functions- "Various common math functions")\
` `| . . . +--> [`banded/math_vector.scad`](matrix.md#vector-operations- "Vector operations")\
` `| . . . +--> [`banded/math_matrix.scad`](matrix.md#matrix-operations- "Matrix operations")\
` `| . . . +--> [`banded/math_formula.scad`](math.md#formula-functions- "Formula functions")\
` `| . . . +--> [`banded/complex.scad`](complex.md "Working with complex numbers")\
` `|\
` `+--> `banded/list.scad`\
` `| . . . +--> [`banded/list_edit.scad`](list.md "Editing lists")\
` `| . . . | . . . . +--> [`banded/list_edit_type.scad`](list.md#different-type-of-data- "Type-dependent access to the content of lists")\
` `| . . . | . . . . +--> [`banded/list_edit_item.scad`](list.md#edit-list-independent-from-the-data- "Edit list independent from the data")\
` `| . . . | . . . . +--> [`banded/list_edit_data.scad`](list.md#edit-list-with-use-of-data-depend-on-type- "Edit list with use of data, type-dependent")\
` `| . . . | . . . . +--> [`banded/list_edit_predicate.scad`](list.md#edit-list-use-function-literal-on-data- "Edit list, use function literal on data")\
` `| . . . +--> [`banded/list_algorithmus.scad`](list_math.md#algorithm-on-lists- "Algorithm on lists")\
` `| . . . +--> [`banded/list_math.scad`](list.md#math-operation-on_each-list-element- "Math operation on each list element")\
` `| . . . +--> [`banded/list_mean.scad`](mean.md "Calculating mean")\
` `|\
` `+--> [`banded/string.scad`](string.md "Functions for edit and convert strings")\
` `| . . . +--> [`banded/string_convert.scad`](string.md#convert-strings- "Convert strings")\
` `| . . . +--> `banded/string_edit.scad`\
` `| . . . . . . . +--> [`banded/string_edit_item.scad`](string.md#edit-strings-independent-from-data- "Edit strings independent from data")\
` `| . . . . . . . +--> [`banded/string_edit_data.scad`](string.md#edit-strings-with-use-of-data- "Edit strings with use of data")\
` `|\
` `+--> `banded/function.scad`\
` `| . . . +--> [`banded/function_algorithmus.scad`](function.md "Algorithmus with function literals")\
` `|\
` `+--> [`banded/helper.scad`](helper.md "Helper functions")\
` `| . . . +--> [`banded/helper_native.scad`](helper.md#native-helper-functions- "Contains various helper functions")\
` `| . . . +--> [`banded/helper_recondition.scad`](helper.md#helper.md#recondition-arguments-of-functions- "Recondition arguments of functions and modules")\
` `|\
` `+--> [`banded/benchmark.scad`](helper.md#benchmark-function- "Benchmark for functions to measure speed")\
` `|\
` `+--> [`banded/extend.scad`](extend.md "Control the level of detail of a mesh")\
` `| . . . +--> [`banded/extend_logic.scad`](extend.md#functions-)\
` `| . . . +--> [`banded/extend_object.scad`](extend.md#defined-modules-)\
` `|\
` `+--> `banded/draft.scad`\
` `| . . . +--> [`banded/draft_curves.scad`](curves.md "Creates curves in a point list")\
` `| . . . +--> [`banded/draft_multmatrix.scad`](multmatrix.md "Multmatrix functions")\
` `| . . . | . . . . +--> [`banded/draft_multmatrix_basic.scad`](multmatrix.md#basic-multmatrix-functions- "Generate matrix like OpenSCAD buildin affine transformation")\
` `| . . . | . . . . +--> [`banded/draft_multmatrix_common.scad`](multmatrix.md#more-multmatrix-functions- "Generate matrix for more affine transformations")\
` `| . . . +--> [`banded/draft_transform.scad`](transform.md "Transform functions on point lists for affine transformations")\
` `| . . . | . . . . +--> [`banded/draft_transform_basic.scad`](transform.md#basic-multmatrix-functions- "OpenSCAD buildin transformation on point lists")\
` `| . . . | . . . . +--> [`banded/draft_transform_common.scad`](transform.md#more-multmatrix-functions- "More functions for affine transformations on point lists")\
` `| . . . |\
` `| . . . +--> [`banded/draft_color.scad`](color.md "Convert colors")\
` `| . . . +--> [`banded/draft_primitives.scad`](primitives.md "Create and edit OpenSCAD primitives in data lists")\
` `| . . . . . . . . +--> `banded/draft_primitives_basic.scad`\
` `| . . . . . . . . +--> `banded/draft_primitives_figure.scad`\
` `| . . . . . . . . +--> `banded/draft_primitives_transform.scad`\
` `|\
` `+--> [`banded/object.scad`](object.md "Configurable objects")\
` `| . . . +--> [`banded/object_figure.scad`](object.md#figures- "Modules to create configurable objects")\
` `| . . . +--> `banded/object_circle.scad`\
` `| . . . +--> [`banded/object_rounded.scad`](object.md#rounded-edges- "Figures with rounded edges")\
` `|\
` `+--> [`banded/operator.scad`](operator.md "Transform and edit objects")\
` `| . . . +--> [`banded/operator_edit.scad`](operator.md#edit-and-test-objects- "Various operator to edit and test objects")\
` `| . . . +--> [`banded/operator_transform.scad`](operator.md#transform-operator- "Transform operator for affine transformations")\
` `| . . . +--> [`banded/operator_place.scad`](operator.md#place-objects- "Modules which place objects in specific position")\
` `|\
` `+--> `banded/other.scad`\
