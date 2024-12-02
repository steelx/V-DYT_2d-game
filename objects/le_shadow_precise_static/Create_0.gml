event_inherited();

var _outline = get_sprite_outline(sprite_index)[image_index],
	_length  = array_length(_outline),
	_verts   = array_create(_length),
	_cos_x   = dcos(image_angle), _cos_y = _cos_x * image_yscale,
	_sin_x   = dsin(image_angle), _sin_y = _sin_x * image_yscale,
	_px, _py, _p = 0, _v = 0;
		
_cos_x *= image_xscale;
_sin_x *= image_xscale;

// Copy verts into new array and apply transforms
while (_p < _length)
{
	_px = _outline[_p++];
	_py = _outline[_p++];
	
	_verts[_v++] = x + _cos_x * _px + _sin_y * _py;
	_verts[_v++] = y - _sin_x * _px + _cos_y * _py;
}

verts = _verts;

function add_shadow(_buff)
{	
	var _verts = verts,
		_length = array_length(_verts),
		_x1 = _verts[_length - 2], 
		_y1 = _verts[_length - 1], 
		_x2, _y2, _n = 0,
		_depth = shadow_depth, _mag = shadow_mag_depth;
		
	while (_n < _length)
	{
		_x2 = _verts[_n++];
		_y2 = _verts[_n++];

		buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);
		
		_x1 = _x2;
		_y1 = _y2;
	}
	
	if (destroy_on_create) instance_destroy(id);
}