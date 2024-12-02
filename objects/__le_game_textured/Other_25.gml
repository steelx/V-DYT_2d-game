/// @description DRAW NORMAL

world_mat = matrix_get(matrix_world);
world_model_mat = matrix_multiply(model_mat, world_mat);

matrix_set(matrix_world, world_model_mat);
vertex_submit(vertex_buffer_normal, pr_trianglelist, tex_normal);
matrix_set(matrix_world, world_mat);