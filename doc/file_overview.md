
Overview of scad files
======================

`banded.scad`\
` `|\
` `+--> `banded/constants.scad`\
` `|\
` `+--> `banded/math.scad`\
` `| . . . +--> `banded/math_common.scad`\
` `| . . . +--> `banded/math_vector.scad`\
` `| . . . +--> `banded/math_matrix.scad`\
` `| . . . +--> `banded/math_formula.scad`\
` `|\
` `+--> [`banded/list.scad`](list.md "Functions for work with lists")\
` `| . . . +--> [`banded/list_edit.scad`](list.md#editing-lists- "Editing lists")\
` `| . . . +--> [`banded/list_algorithmus.scad`](list.md#algorithm-on-lists- "Algorithm on lists")\
` `| . . . +--> [`banded/list_math.scad`](list.md#math-on-lists- "Math on lists")\
` `| . . . +--> [`banded/list_mean.scad`](list.md#calculating-mean- "Calculating mean")\
` `|\
` `+--> `banded/function.scad`\
` `| . . . +--> `banded/function_select.scad`\
` `| . . . +--> `banded/function_algorithmus.scad`\
` `| . . . +--> `banded/function_list_edit.scad`\
` `|\
` `+--> `banded/helper.scad`\
` `| . . . +--> `banded/helper_native.scad`\
` `| . . . +--> `banded/helper_recondition.scad`\
` `|\
` `+--> [`banded/extend.scad`](extend.md "Control the level of detail of a mesh")\
` `| . . . +--> [`banded/extend_logic.scad`](extend.md#functions-)\
` `| . . . +--> [`banded/extend_object.scad`](extend.md#defined-modules-)\
` `|\
` `+--> [`banded/draft.scad`](draft.md "Draft objects in a point list")\
` `| . . . +--> [`banded/draft_curves.scad`](draft.md#curves- "Creates curves in a list")\
` `| . . . +--> [`banded/draft_transform.scad`](draft.md#transform-functions- "Transform functions for affine transformations")\
` `| . . . | . . . . +--> [`banded/draft_transform_basic.scad`](draft.md#basic-multmatrix-functions- "OpenScad buildin transformation on point lists")\
` `| . . . | . . . . +--> [`banded/draft_transform_common.scad](draft.md#more-multmatrix-functions- "More functions for affine transformations")`\
` `| . . . +--> [`banded/draft_multmatrix.scad`](draft.md#multmatrix- "Multmatrix functions")\
` `| . . . | . . . . +--> [`banded/draft_multmatrix_basic.scad`](draft.md#basic-multmatrix-functions- "Generate matrix like OpenScad buildin affine transformation")\
` `| . . . | . . . . +--> [`banded/draft_multmatrix_common.scad`](draft.md#more-multmatrix-functions- "Generate matrix for more affine transformations")\
` `| . . . |
` `| . . . +--> `banded/draft_transform_names.scad`\
` `|\
` `+--> `banded/object.scad`\
` `| . . . +--> `banded/object_basic.scad`\
` `| . . . +--> `banded/object_circle.scad`\
` `| . . . +--> `banded/object_rounded.scad`\
` `|\
` `+--> [`banded/operator.scad`](operator.md "Transform and edit objects")\
` `| . . . +--> `banded/operator_edit.scad`\
` `| . . . +--> [`banded/operator_transform.scad`](operator.md#transform-operator- "Transform operator for affine transformations")\
` `| . . . +--> `banded/operator_place.scad`\
` `|\
` `+--> `banded/benchmark.scad`\
` `|\
` `+--> `banded/other.scad`\
