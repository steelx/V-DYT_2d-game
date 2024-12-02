slog("Cleaning up lighting");
free_lighting_surfaces();

if (buffer_exists(buffer_lights))
	buffer_delete(buffer_lights);

// Cannot rely on buffer_exists for vertex buffers...
if (vertex_buffer != vertex_buffer_dummy) vertex_delete_buffer(vertex_buffer_dummy);
if (vertex_buffer != noone) vertex_delete_buffer(vertex_buffer);

vertex_format_delete(vertex_format);

if ds_exists(shadow_grid, ds_type_grid)
{
	var _grid = shadow_grid;
	for (var _c = 0, _cols = ds_grid_width(_grid); _c < _cols; _c++)
		for (var _r = 0, _rows = ds_grid_height(_grid); _r < _rows; _r++)
			_grid[# _c, _r].destroy();
	
	ds_grid_destroy(shadow_grid);
}

layer_params_clear_material();
layer_params_clear_normal();