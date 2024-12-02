/// @description Shadow Atlas Params

var _width  = surface_get_width(application_surface),
	_height = surface_get_height(application_surface);

// Just in case it was set higher than the atlas
shadow_map_size = min(shadow_map_size, shadow_atlas_size);
		
if (_width > _height)
{
	var _aspect         = _height/_width;
	shadow_map_width    = shadow_map_size;
	shadow_map_height   = shadow_map_size * _aspect;
	shadow_map_cols     = shadow_atlas_size div shadow_map_size;
	shadow_map_rows     = shadow_atlas_size div shadow_map_height;	
	
	shadow_atlas_width  = shadow_atlas_size;
	shadow_atlas_height = shadow_map_height * shadow_map_rows;
}
else
{
	var _aspect         = _width/_height;
	shadow_map_height   = shadow_map_size;
	shadow_map_width    = shadow_map_size * _aspect;
	shadow_map_cols     = shadow_atlas_size div shadow_map_width;
	shadow_map_rows     = shadow_atlas_size div shadow_map_size;
	
	shadow_atlas_width  = shadow_map_width * shadow_map_cols;
	shadow_atlas_height = shadow_atlas_size;
}

// Normalized surface space is -1 to 1, so divide by its magnitude which is 2
shadow_map_cell_x   = 2/shadow_map_cols;
shadow_map_cell_y   = 2/shadow_map_rows;

light_batch_size = shadow_map_rows * shadow_map_cols * 4;
if surface_exists(shadow_atlas) surface_free(shadow_atlas);





