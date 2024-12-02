/// @description DRAW ALBEDO

var _world = matrix_get(matrix_world);
matrix_set(matrix_world, model_mat);
vertex_submit(vertex_buffer_albedo, pr_trianglelist, tex_albedo);
matrix_set(matrix_world, _world);
