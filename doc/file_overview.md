Overview of scad files
======================

[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [In root folder](#in-root-folder-)
- [In main folder `banded/`](#in-main-folder-banded-)
- [Antiquity files](#antiquity-files-)


#### In root folder [^][contents]
`banded.scad` --> `banded/banded.scad`  

#### In main folder `banded/` [^][contents]
`banded.scad`  
` `|  
` `+--> [`constants.scad`](constants.md "Define some constants")  
` `| . . . +--> [`constants_user.scad`](constants.md#customizable-constants- "Customizable constants")  
` `| . . . +--> [`constants_technical.scad`](constants.md#technical-constants- "Technical constants")  
` `| . . . +--> `constants_helper.scad`  
` `|  
` `+--> [`math.scad`](math.md "Math functions")  
` `| . . . +--> [`math_common.scad`](math.md#more-math-functions- "Various common math functions")  
` `| . . . +--> [`math_formula.scad`](math.md#formula-functions- "Formula functions")  
` `| . . . +--> [`math_number.scad`](math.md#number-functions- "Number functions")  
` `| . . . +--> [`math_vector.scad`](math_vector.md "Vector operations")  
` `| . . . +--> [`math_matrix.scad`](math_matrix.md "Matrix operations")  
` `| . . . +--> [`math_polygon.scad`](math_polygon.md "Polygones and lines operations")  
` `| . . . +--> [`math_function.scad`](math_function.md "Algorithm with function literals")  
` `| . . . +--> [`complex.scad`](math_complex.md "Working with complex numbers")  
` `|  
` `+--> `list.scad`  
` `| . . . +--> [`list_edit.scad`](list.md "Editing lists")  
` `| . . . | . . . . +--> [`list_edit_type.scad`](list.md#different-type-of-data- "Type-dependent access to the content of lists")  
` `| . . . | . . . . +--> [`list_edit_item.scad`](list.md#edit-list-independent-from-the-data- "Edit list independent from the data")  
` `| . . . | . . . . +--> [`list_edit_data.scad`](list.md#edit-list-with-use-of-data-depend-on-type- "Edit list with use of data, type-dependent")  
` `| . . . | . . . . +--> [`list_edit_info.scad`](list.md#get-data-from-list- "Get data from list with use of data, type-dependent")  
` `| . . . | . . . . +--> [`list_edit_predicate.scad`](list.md#edit-list-use-function-literal-on-data- "Edit list, use function literal on data")  
` `| . . . | . . . . +--> [`list_edit_test.scad`](list.md##test-entries-of-lists- "Test entries of lists")  
` `| . . . | . . . . +--> [`list_edit_pair.scad`](list.md#pair-functions- "Pair functions - key-value-pair")  
` `| . . . +--> [`list_algorithm.scad`](list_math.md#algorithm-on-lists- "Algorithm on lists")  
` `| . . . +--> [`list_math.scad`](list.md#math-operation-on_each-list-element- "Math operation on each list element")  
` `| . . . +--> [`list_mean.scad`](list_mean.md "Calculating mean")  
` `|  
` `+--> [`string.scad`](string.md "Functions for edit and convert strings")  
` `| . . . +--> [`string_convert.scad`](string.md#convert-strings- "Convert strings")  
` `| . . . +--> [`string_character.scad`](string.md#convert-and-test-letter-in-strings- "Convert and test letter in strings")  
` `| . . . +--> [`string_edit.scad`](string.md#edit-letter-in-strings- "Edit letter in strings")  
` `| . . . +--> [`string_format.scad`](string.md#format-strings- "Format strings")  
` `|  
` `+--> [`helper.scad`](helper.md "Helper functions")  
` `| . . . +--> [`helper_native.scad`](helper.md#native-helper-functions- "Contains various helper functions")  
` `| . . . +--> [`helper_arguments.scad`](helper.md#helper.md#configure-arguments- "Recondition arguments of functions and modules")  
` `| . . . +--> [`helper_recondition.scad`](helper.md#helper.md#recondition-arguments-of-functions- "Configure arguments from functions or modules to expand further control options")  
` `| . . . +--> `helper_primitives.scad`  
` `| . . . | . . . . +--> `helper_primitives_path.scad`  
` `| . . . | . . . . +--> `helper_primitives_trace.scad`  
` `|  
` `+--> [`extend.scad`](extend.md "Control the level of detail of a mesh")  
` `| . . . +--> [`extend_logic.scad`](extend.md#functions-)  
` `| . . . | . . . . +--> [`extend_logic_helper.scad`](extend.md#convert-values- "Helper functions: convert values, and for internal use")  
` `| . . . | . . . . +--> [`extend_logic_circle.scad`](extend.md#get-fragments-of-a-circle- "Get fragments of a circle")  
` `| . . . | . . . . +--> `extend_linear_extrude.scad`  
` `| . . . +--> [`extend_object.scad`](extend.md#defined-modules-)  
` `|  
` `+--> `draft.scad`  
` `| . . . +--> [`draft_curves.scad`](draft_curves.md "Creates curves in a point list")  
` `| . . . +--> [`draft_surface.scad`](draft_surface.md "Creates surfaces as data list")  
` `| . . . +--> [`draft_matrix.scad`](draft_matrix.md "Generate matrices for affine transformation")  
` `| . . . | . . . . +--> [`draft_matrix_basic.scad`](draft_matrix.md#basic-multmatrix-functions- "Generate matrix like OpenSCAD buildin affine transformation")  
` `| . . . | . . . . +--> [`draft_matrix_common.scad`](draft_matrix.md#more-multmatrix-functions- "Generate matrix for more affine transformations")  
` `| . . . +--> [`draft_transform.scad`](draft_transform.md "Transform functions on point lists for affine transformations")  
` `| . . . | . . . . +--> [`draft_transform_basic.scad`](draft_transform.md#basic-multmatrix-functions- "OpenSCAD buildin transformation on point lists")  
` `| . . . | . . . . +--> [`draft_transform_common.scad`](draft_transform.md#more-multmatrix-functions- "More functions for affine transformations on point lists")  
` `| . . . |  
` `| . . . +--> [`draft_primitives.scad`](draft_primitives.md "Create and edit OpenSCAD primitives in data lists")  
` `| . . . . . . . . +--> `draft_primitives_basic.scad`  
` `| . . . . . . . . +--> `draft_primitives_figure.scad`  
` `| . . . . . . . . +--> `draft_primitives_transform.scad`  
` `| . . . . . . . . +--> `draft_primitives_operator.scad`  
` `|  
` `+--> [`color.scad`](color.md "Convert colors")  
` `| . . . +--> `color_definition.scad`  
` `| . . . +--> `color/*.scad`  
` `|  
` `+--> [`font.scad`](draft_primitives.md#text-)  
` `| . . . +--> `font_definition.scad`  
` `| . . . +--> `font/*.scad`  
` `|  
` `+--> [`object.scad`](object.md "Configurable objects")  
` `| . . . +--> [`object_figure.scad`](object.md#figures- "Modules to create configurable objects")  
` `| . . . +--> [`object_figure_rounded.scad`](object.md#figures-with-chamfered-edges- "Configurable objects with chamfered edges")  
` `| . . . +--> [`object_rounded.scad`](object.md#rounded-edges- "Figures to create rounded edges")  
` `|  
` `+--> [`operator.scad`](operator.md "Transform and edit objects")  
` `| . . . +--> [`operator_edit.scad`](operator.md#edit-and-test-objects- "Various operator to edit and test objects")  
` `| . . . +--> [`operator_transform.scad`](operator.md#transform-operator- "Transform operator for affine transformations")  
` `| . . . +--> [`operator_place.scad`](operator.md#place-objects- "Modules which place objects in specific position")  
` `|  
` `+--> [`debug.scad`](debug.md "Debug modules - make parts and points seeable")  
` `|  
` `+--> [`benchmark.scad`](debug.md#benchmark-function- "Benchmark for functions to measure speed")  
` `|  
` `+--> [`version.scad`](version.md "Functions and modules to manage versioning")  
` `| . . . +--> `version_helper.scad`  
` `|  
` `+--> `other.scad`  

#### Antiquity files [^][contents]
[`antiquity/*`](antiquity.md)  
` `|  
` `+- `compatibility_v2015.scad`  
` `+- `compatibility_v2015_assert.scad`  
` `|  
` `+- `compatibility_v2019.scad`  
