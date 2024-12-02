// Duplicates an albedo layers tile indexes into normal and material map
// tile layers.  Used so you do not have to place normal and material
// tile map layers manually.

// The normal and material tile map layers MUST still be created in the room 
// with the appropriate tile map assigned, but you do not need to actually place 
// anything since it is copied from the albedo.

var _norm_id = layer_get_id(layer_normal),
	_mat_id  = layer_get_id(layer_material),
	_base    = layer_tilemap_get_id(layer_get_id(layer_base)),
	_norm    = layer_tilemap_get_id(_norm_id),
	_mat     = layer_tilemap_get_id(_mat_id);

// Verify all layers exist
if (_base == -1 || _norm == -1 || _mat == -1)
{
	instance_destroy(id);
	exit;	
}

var _w = tilemap_get_width(_base),
	_h = tilemap_get_height(_base),
	_data = noone;
		
for (var _c = 0; _c < _w; _c++)
{
	for (var _r = 0; _r < _h; _r++)
	{
		_data = tilemap_get(_base, _c, _r);
		tilemap_set(_norm, _data, _c, _r);
		tilemap_set(_mat,  _data, _c, _r);
	}
}


if (add_layer_scripts)
{
	set_layer_scripts_material(_mat_id, has_occlusion, shadow_depth);
	set_layer_scripts_normal(_norm_id, emissive);
}

instance_destroy(id);