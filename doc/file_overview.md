Overview of scad files
======================

`banded.scad`\
` `|\
` `+--> `banded/constants.scad`\
` `| . . . +--> `banded/constants_helper.scad`\
` `|\
` `+--> [`banded/math.scad`](math.md "Math functions")\
` `| . . . +--> [`banded/math_common.scad`](math.md#more-math-functions- "Common math functions")\
` `| . . . +--> [`banded/math_vector.scad`](matrix.md#vector-operations- "Vector operations")\
` `| . . . +--> [`banded/math_matrix.scad`](matrix.md#matrix-operations- "Matrix operations")\
` `| . . . +--> [`banded/math_formula.scad`](math.md#formula-functions- "Formula functions")\
` `| . . . +--> [`banded/complex.scad`](complex.md "Working with complex numbers")\
` `|\
` `+--> [`banded/list.scad`](list.md "Functions for work with lists")\
` `| . . . +--> [`banded/list_edit.scad`](list.md#editing-lists- "Editing lists")\
` `| . . . | . . . . +--> [`banded/list_edit_type.scad`](list.md#different-type-of-data- "Type-dependent access to the content of lists")\
` `| . . . | . . . . +--> [`banded/list_edit_item.scad`](list.md#edit-list-independent-from-the-data- "Edit list independent from the data")\
` `| . . . | . . . . +--> [`banded/list_edit_data.scad`](list.md#edit-list-with-use-of-data- "Edit list with use of data, type-dependent")\
` `| . . . +--> [`banded/list_algorithmus.scad`](list.md#algorithm-on-lists- "Algorithm on lists")\
` `| . . . +--> [`banded/list_math.scad`](list.md#math-on-lists- "Math on lists")\
` `| . . . +--> [`banded/list_mean.scad`](list.md#calculating-mean- "Calculating mean")\
` `|\
` `+--> [`banded/string.scad`](string.md "Functions for edit and convert strings")\
` `| . . . +--> [`banded/string_convert.scad`](string.md#convert-strings- "Convert strings")\
` `| . . . +--> `banded/string_edit.scad`\
` `| . . . . . . . +--> [`banded/string_edit_item.scad`](string.md#edit-strings-independent-from-data- "Edit strings independent from data")\
` `| . . . . . . . +--> [`banded/string_edit_data.scad`](string.md#edit-strings-with-use-of-data- "Edit strings with use of data")\
` `|\
` `+--> `banded/function.scad`\
` `| . . . +--> `banded/function_algorithmus.scad`\
` `| . . . +--> `banded/function_list_edit.scad`\
` `|\
` `+--> [`banded/helper.scad`](helper.md "Helper functions")\
` `| . . . +--> `banded/helper_native.scad`\
` `| . . . +--> `banded/helper_recondition.scad`\
` `|\
` `+--> [`banded/benchmark.scad`](helper.md#benchmark-function- "Benchmark functions to measure speed")\
` `|\
` `+--> [`banded/extend.scad`](extend.md "Control the level of detail of a mesh")\
` `| . . . +--> [`banded/extend_logic.scad`](extend.md#functions-)\
` `| . . . +--> [`banded/extend_object.scad`](extend.md#defined-modules-)\
` `|\
` `+--> [`banded/draft.scad`](draft.md "Draft objects in a point list")\
` `| . . . +--> [`banded/draft_curves.scad`](draft.md#curves- "Creates curves in a list")\
` `| . . . +--> [`banded/draft_multmatrix.scad`](draft.md#multmatrix- "Multmatrix functions")\
` `| . . . | . . . . +--> [`banded/draft_multmatrix_basic.scad`](draft.md#basic-multmatrix-functions- "Generate matrix like OpenSCAD buildin affine transformation")\
` `| . . . | . . . . +--> [`banded/draft_multmatrix_common.scad`](draft.md#more-multmatrix-functions- "Generate matrix for more affine transformations")\
` `| . . . +--> [`banded/draft_transform.scad`](draft.md#transform-functions- "Transform functions on point lists for affine transformations")\
` `| . . . . . . . . +--> [`banded/draft_transform_basic.scad`](draft.md#basic-multmatrix-functions- "OpenSCAD buildin transformation on point lists")\
` `| . . . . . . . . +--> [`banded/draft_transform_common.scad`](draft.md#more-multmatrix-functions- "More functions for affine transformations on point lists")\
` `|\
` `+--> `banded/object.scad`\
` `| . . . +--> `banded/object_figure.scad`\
` `| . . . +--> `banded/object_circle.scad`\
` `| . . . +--> `banded/object_rounded.scad`\
` `|\
` `+--> [`banded/operator.scad`](operator.md "Transform and edit objects")\
` `| . . . +--> `banded/operator_edit.scad`\
` `| . . . +--> [`banded/operator_transform.scad`](operator.md#transform-operator- "Transform operator for affine transformations")\
` `| . . . +--> [`banded/operator_place.scad`](operator.md#place-objects- "Modules which place objects in specific position")\
` `|\
` `+--> `banded/other.scad`\
