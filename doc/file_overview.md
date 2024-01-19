Overview of scad files
======================

[<-- table of contents](contents.md)

`banded.scad`\
` `|\
` `+--> [`banded/constants.scad`](constants.md "Define some constants")\
` `| . . . +--> [`banded/constants_user.scad`](constants.md#customizable-constants- "Customizable constants")\
` `| . . . +--> `banded/constants_helper.scad`\
` `|\
` `+--> [`banded/math.scad`](math.md "Math functions")\
` `| . . . +--> [`banded/math_common.scad`](math.md#more-math-functions- "Various common math functions")\
` `| . . . +--> [`banded/math_formula.scad`](math.md#formula-functions- "Formula functions")\
` `| . . . +--> [`banded/math_number.scad`](math.md#number-functions- "Number functions")\
` `| . . . +--> [`banded/math_vector.scad`](math_vector.md "Vector operations")\
` `| . . . +--> [`banded/math_matrix.scad`](math_matrix.md "Matrix operations")\
` `| . . . +--> [`banded/math_polygon.scad`](math_matrix.md#polygones-and-lines- "Polygones and lines operations")\
` `| . . . +--> [`banded/complex.scad`](math_complex.md "Working with complex numbers")\
` `|\
` `+--> `banded/function.scad`\
` `| . . . +--> [`banded/function_algorithmus.scad`](function.md "Algorithmus with function literals")\
` `|\
` `+--> `banded/list.scad`\
` `| . . . +--> [`banded/list_edit.scad`](list.md "Editing lists")\
` `| . . . | . . . . +--> [`banded/list_edit_type.scad`](list.md#different-type-of-data- "Type-dependent access to the content of lists")\
` `| . . . | . . . . +--> [`banded/list_edit_item.scad`](list.md#edit-list-independent-from-the-data- "Edit list independent from the data")\
` `| . . . | . . . . +--> [`banded/list_edit_data.scad`](list.md#edit-list-with-use-of-data-depend-on-type- "Edit list with use of data, type-dependent")\
` `| . . . | . . . . +--> [`banded/list_edit_info.scad`](list.md#get-data-from-list- "Get data from list with use of data, type-dependent")\
` `| . . . | . . . . +--> [`banded/list_edit_predicate.scad`](list.md#edit-list-use-function-literal-on-data- "Edit list, use function literal on data")\
` `| . . . | . . . . +--> [`banded/list_edit_test.scad`](list.md##test-entries-of-lists- "Test entries of lists")\
` `| . . . | . . . . +--> [`banded/list_edit_pair.scad`](list.md#pair-functions- "Pair functions - key-value-pair")\
` `| . . . +--> [`banded/list_algorithmus.scad`](list_math.md#algorithm-on-lists- "Algorithm on lists")\
` `| . . . +--> [`banded/list_math.scad`](list.md#math-operation-on_each-list-element- "Math operation on each list element")\
` `| . . . +--> [`banded/list_mean.scad`](list_mean.md "Calculating mean")\
` `|\
` `+--> [`banded/string.scad`](string.md "Functions for edit and convert strings")\
` `| . . . +--> [`banded/string_convert.scad`](string.md#convert-strings- "Convert strings")\
` `| . . . +--> [`banded/string_character.scad`](string.md#convert-and-test-letter-in-strings- "Convert and test letter in strings")\
` `| . . . +--> [`banded/string_edit.scad`](string.md#edit-letter-in-strings- "Edit letter in strings")\
` `| . . . +--> [`banded/string_format.scad`](string.md#format-strings- "Format strings")\
` `|\
` `+--> [`banded/helper.scad`](helper.md "Helper functions")\
` `| . . . +--> [`banded/helper_native.scad`](helper.md#native-helper-functions- "Contains various helper functions")\
` `| . . . +--> [`banded/helper_recondition.scad`](helper.md#helper.md#recondition-arguments-of-functions- "Recondition arguments of functions and modules")\
` `| . . . +--> `banded/helper_primitives.scad`\
` `| . . . | . . . . +--> `banded/helper_primitives_path.scad`\
` `| . . . | . . . . +--> `banded/helper_primitives_trace.scad`\
` `|\
` `+--> [`banded/benchmark.scad`](helper.md#benchmark-function- "Benchmark for functions to measure speed")\
` `|\
` `+--> [`banded/extend.scad`](extend.md "Control the level of detail of a mesh")\
` `| . . . +--> [`banded/extend_logic.scad`](extend.md#functions-)\
` `| . . . | . . . . +--> [`banded/extend_logic_helper.scad`](extend.md#convert-values- "Helper functions: convert values, and for internal use")\
` `| . . . | . . . . +--> [`banded/extend_logic_circle.scad`](extend.md#get-fragments-of-a-circle- "Get fragments of a circle")\
` `| . . . | . . . . +--> `banded/extend_linear_extrude.scad`\
` `| . . . +--> [`banded/extend_object.scad`](extend.md#defined-modules-)\
` `|\
` `+--> `banded/draft.scad`\
` `| . . . +--> [`banded/draft_curves.scad`](draft_curves.md "Creates curves in a point list")\
` `| . . . +--> [`banded/draft_matrix.scad`](draft_matrix.md "Generate matrices for affine transformation")\
` `| . . . | . . . . +--> [`banded/draft_matrix_basic.scad`](draft_matrix.md#basic-multmatrix-functions- "Generate matrix like OpenSCAD buildin affine transformation")\
` `| . . . | . . . . +--> [`banded/draft_matrix_common.scad`](draft_matrix.md#more-multmatrix-functions- "Generate matrix for more affine transformations")\
` `| . . . +--> [`banded/draft_transform.scad`](draft_transform.md "Transform functions on point lists for affine transformations")\
` `| . . . | . . . . +--> [`banded/draft_transform_basic.scad`](draft_transform.md#basic-multmatrix-functions- "OpenSCAD buildin transformation on point lists")\
` `| . . . | . . . . +--> [`banded/draft_transform_common.scad`](draft_transform.md#more-multmatrix-functions- "More functions for affine transformations on point lists")\
` `| . . . |\
` `| . . . +--> [`banded/draft_color.scad`](color.md "Convert colors")\
` `| . . . +--> [`banded/draft_primitives.scad`](draft_primitives.md "Create and edit OpenSCAD primitives in data lists")\
` `| . . . . . . . . +--> `banded/draft_primitives_basic.scad`\
` `| . . . . . . . . +--> `banded/draft_primitives_figure.scad`\
` `| . . . . . . . . +--> `banded/draft_primitives_transform.scad`\
` `| . . . . . . . . +--> `banded/draft_primitives_operator.scad`\
` `|\
` `+--> [`banded/font.scad`](draft_primitives.md#text-)\
` `| . . . +--> `banded/font_definition.scad`\
` `| . . . +--> `banded/font/*.scad`\
` `|\
` `+--> [`banded/object.scad`](object.md "Configurable objects")\
` `| . . . +--> [`banded/object_figure.scad`](object.md#figures- "Modules to create configurable objects")\
` `| . . . +--> [`banded/object_figure_rounded.scad`](object.md#figures-with-rounded-edges- "Configurable objects with rounded edges")\
` `| . . . +--> [`banded/object_rounded.scad`](object.md#rounded-edges- "Figures to create rounded edges")\
` `|\
` `+--> [`banded/operator.scad`](operator.md "Transform and edit objects")\
` `| . . . +--> [`banded/operator_edit.scad`](operator.md#edit-and-test-objects- "Various operator to edit and test objects")\
` `| . . . +--> [`banded/operator_transform.scad`](operator.md#transform-operator- "Transform operator for affine transformations")\
` `| . . . +--> [`banded/operator_place.scad`](operator.md#place-objects- "Modules which place objects in specific position")\
` `|\
` `+--> [`banded/debug.scad`](debug.md "Debug modules - make parts and points seeable")\
` `|\
` `+--> `banded/other.scad`

[`antiquity/*`](antiquity.md)\
` `|\
` `+- `compatibility_v2015.scad`\
` `+- `compatibility_v2015_assert.scad`\
` `|\
` `+- `compatibility_v2019.scad`
