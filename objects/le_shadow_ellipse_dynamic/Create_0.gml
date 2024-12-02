event_inherited();

rad_increment = LE_2PI / circle_divisions;

function add_shadow(_buff)
{	
	var _x = (bbox_left + bbox_right) * 0.5, _y = (bbox_top + bbox_bottom) * 0.5,
		_a = sprite_width * 0.5, _b = sprite_height * -0.5,
		_inc = rad_increment, _divs = circle_divisions,
		_rad = _inc,
		_x1 = _x + _a, _y1 = _y,
		_x2, _y2,
		_depth = shadow_depth, _mag = shadow_mag_depth;
	
	if (image_angle == 0)
	{	
		for (var _t = 0; _t < _divs; _t++)
		{
			_x2 = _x + cos(_rad) * _a;
			_y2 = _y - sin(_rad) * _b;
		
			buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);
		
			_x1 = _x2;
			_y1 = _y2;
			_rad += _inc;
		}
	}
	else
	{
		var _tcos = dcos(image_angle),
			_tsin = dsin(image_angle),
			_px = _x + _tcos * _a,
			_py = _y - _tsin * _a;
		
		for (var _t = 0; _t < _divs; _t++)
		{
			_x2 = cos(_rad) * _a;
			_y2 = sin(_rad) * _b;
			
			_x1 = _x + _tcos * _x2 - _tsin * _y2;
			_y1 = _y - _tsin * _x2 - _tcos * _y2; 
		
			buffer_write_shadow_quad(_buff, _px, _py, _x1, _y1, _depth, _mag);
				
			_px = _x1;
			_py = _y1;
			_rad += _inc;
		}
	}
}