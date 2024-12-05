event_inherited();

rad_increment = LE_2PI / circle_divisions;

function add_shadow(_buff)
{	
	var _x = (bbox_left + bbox_right) * 0.5, _y = (bbox_top + bbox_bottom) * 0.5,
		_r = sprite_width * 0.5,
		_inc = rad_increment, _divs = circle_divisions,
		_rad = _inc,
		_x1 = _x + _r, _y1 = _y,
		_x2, _y2,
		_depth = shadow_depth, _mag = shadow_mag_depth;
	
	for (var _t = 0; _t < _divs; _t++)
	{
		_x2 = _x + cos(_rad) * _r;
		_y2 = _y - sin(_rad) * _r;
		
		buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);
		
		_x1 = _x2;
		_y1 = _y2;
		_rad += _inc;
	}
}