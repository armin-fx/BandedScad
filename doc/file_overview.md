
Overview of scad files
======================

`tools.scad`\
` `|\
` `+--> `tools/constants.scad`\
` `|\
` `+--> `tools/math.scad`\
` `| . . . +--> `tools/math_common.scad`\
` `| . . . +--> `tools/math_vector.scad`\
` `| . . . +--> `tools/math_matrix.scad`\
` `| . . . +--> `tools/math_formula.scad`\
` `|\
` `+--> [`tools/list.scad`](list.md "Functions for editing lists")\
` `| . . . +--> `tools/list_edit.scad`\
` `| . . . +--> `tools/list_algorithmus.scad`\
` `| . . . +--> `tools/list_math.scad`\
` `| . . . +--> `tools/list_mean.scad`\
` `|\
` `+--> `tools/function.scad`\
` `| . . . +--> `tools/function_select.scad`\
` `| . . . +--> `tools/function_algorithmus.scad`\
` `| . . . +--> `tools/function_list_edit.scad`\
` `|\
` `+--> `tools/helper.scad`\
` `| . . . +--> `tools/helper_native.scad`\
` `| . . . +--> `tools/helper_recondition.scad`\
` `|\
` `+--> [`tools/extend.scad`](extend.md "Control the level of detail of a mesh")\
` `| . . . +--> [`tools/extend_logic.scad`](extend.md#functions-)\
` `| . . . +--> [`tools/extend_object.scad`](extend.md#defined-modules-)\
` `|\
` `+--> [`tools/draft.scad`](draft.md "Draft objects in a point list")\
` `| . . . +--> [`tools/draft_curves.scad`](draft.md#curves- "Creates curves in a list")\
` `| . . . +--> [`tools/draft_transform.scad`](draft.md#transform-functions- "Transform functions for affine transformations")\
` `| . . . | . . . . +--> `tools/draft_transform_basic.scad`\
` `| . . . | . . . . +--> `tools/draft_transform_common.scad`\
` `| . . . +--> [`tools/draft_multmatrix.scad`](draft.md#multmatrix- "Multmatrix functions")\
` `| . . . | . . . . +--> `tools/draft_multmatrix_basic.scad`\
` `| . . . | . . . . +--> `tools/draft_multmatrix_common.scad`\
` `| . . . |
` `| . . . +--> `tools/draft_transform_names.scad`\
` `|\
` `+--> `tools/object.scad`\
` `| . . . +--> `tools/object_basic.scad`\
` `| . . . +--> `tools/object_circle.scad`\
` `| . . . +--> `tools/object_rounded.scad`\
` `|\
` `+--> `tools/operator.scad`\
` `| . . . +--> `tools/operator_edit.scad`\
` `| . . . +--> `tools/operator_transform.scad`\
` `| . . . +--> `tools/operator_place.scad`\
` `|\
` `+--> `tools/benchmark.scad`\
` `|\
` `+--> `tools/other.scad`\
