event_inherited();

function add_shadow(_buff)
{	
	var _verts   = get_sprite_outline(sprite_index)[image_index],
		_length  = array_length(_verts) - 1,
		_cos_x   = dcos(image_angle), 
		_cos_y   = _cos_x * image_yscale,
		_sin_x   = dsin(image_angle), 
		_sin_y   = _sin_x * image_yscale,
		_x2      = 0,
		_y2      = 0,
		_px      = _verts[_length - 1],
		_py      = _verts[_length],
		_v       = 0,
		_depth   = shadow_depth, 
		_mag     = shadow_mag_depth;
		
	_cos_x *= image_xscale;
	_sin_x *= image_xscale;
		
	var _x1 = x + _cos_x * _px + _sin_y * _py,
		_y1 = y - _sin_x * _px + _cos_y * _py;
				
	while (_v < _length)
	{
		_px = _verts[_v++];
		_py = _verts[_v++];
		
		_x2 = x + _cos_x * _px + _sin_y * _py;
		_y2 = y - _sin_x * _px + _cos_y * _py;

		buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);
		
		_x1 = _x2;
		_y1 = _y2;
	}
	
}