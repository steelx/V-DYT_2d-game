event_inherited();

// Process path points
var _path = shadow_path,
	_points = path_get_number(shadow_path),
	_vx = array_create(_points),
	_vy = array_create(_points),
	_x_off = sprite_get_xoffset(sprite_index),
	_y_off = sprite_get_yoffset(sprite_index);
	
	for (var _n = 0; _n < _points; _n++)
	{
		_vx[_n] = path_get_point_x(_path, _n) - _x_off;
		_vy[_n] = path_get_point_y(_path, _n) - _y_off;
	}

verts_x = _vx;
verts_y = _vy;

// If shadow edges should loop or not
if path_get_closed(_path)
{
	start_index = 0;
	first_vert = _points - 1;
}
else
{
	start_index = 1;
	first_vert = 0;
}

function add_shadow(_buff)
{
	var _cos_x = dcos(image_angle), _cos_y = _cos_x * image_yscale,
		_sin_x = dsin(image_angle), _sin_y = _sin_x * image_yscale,
		_length = array_length(verts_x),
		_x2 = verts_x[first_vert],
		_y2 = verts_y[first_vert],
		_depth = shadow_depth, _mag = shadow_mag_depth;
		
	_cos_x *= image_xscale;
	_sin_x *= image_xscale;
		
	var _x1 = x + _cos_x * _x2 + _sin_y * _y2,
		_y1 = y - _sin_x * _x2 + _cos_y * _y2;
		
	for (var _n = start_index; _n < _length; _n++)
	{
		_x2 = x + _cos_x * verts_x[_n] + _sin_y * verts_y[_n];
		_y2 = y - _sin_x * verts_x[_n] + _cos_y * verts_y[_n];
		
		buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);
		
		_x1 = _x2;
		_y1 = _y2;
	}
}