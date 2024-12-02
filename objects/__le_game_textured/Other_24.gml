/// @description DRAW MATERIAL

matrix_set(matrix_world, world_model_mat);
vertex_submit(vertex_buffer_material, pr_trianglelist, tex_material);
matrix_set(matrix_world, world_mat);