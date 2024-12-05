event_inherited();

// Process path points
var _path = shadow_path,
	_points = path_get_number(shadow_path),
	_vx = array_create(_points),
	_vy = array_create(_points);
	
	for (var _n = 0; _n < _points; _n++)
	{
		_vx[_n] = path_get_point_x(_path, _n);
		_vy[_n] = path_get_point_y(_path, _n);
	}

verts_x = _vx;
verts_y = _vy;

// Transform if not using the exact room coordinates of the path
if (transform)
{
	var _x_off = sprite_get_xoffset(sprite_index), _y_off = sprite_get_yoffset(sprite_index),
		_cos_x = dcos(image_angle), _cos_y = _cos_x * image_yscale,
		_sin_x = dsin(image_angle), _sin_y = _sin_x * image_yscale,
		_px, _py;
		
	_cos_x *= image_xscale;
	_sin_x *= image_xscale;
	
	for (var _p = 0; _p < _points; _p++)
	{
		_px = verts_x[_p] - _x_off;
		_py = verts_y[_p] - _y_off;

		verts_x[_p] = x + _cos_x * _px + _sin_y * _py;
		verts_y[_p] = y - _sin_x * _px + _cos_y * _py;
	}
}

function add_shadow(_buff)
{	
	var _length = array_length(verts_x),
		_x1, _y1, _x2, _y2, _start, 
		_depth = shadow_depth, _mag = shadow_mag_depth;
	
	// Loop the path edge or not
	if path_get_closed(shadow_path)
	{
		_x1 = verts_x[_length - 1];
		_y1 = verts_y[_length - 1];
		_start = 0;
	}
	else
	{
		_x1 = verts_x[0];
		_y1 = verts_y[0];
		_start = 1;
	}
		
	for (var _n = _start; _n < _length; _n++)
	{
		_x2 = verts_x[_n];
		_y2 = verts_y[_n];
		
		buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);
		
		_x1 = _x2;
		_y1 = _y2;
	}
	
	if (destroy_on_create) instance_destroy(id);
}