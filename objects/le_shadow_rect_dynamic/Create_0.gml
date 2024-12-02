event_inherited();

function add_shadow(_buff)
{
	var _x = (bbox_left + bbox_right) * 0.5, _y = (bbox_top + bbox_bottom) * 0.5,
		_w = sprite_width * 0.5, _h = sprite_height * 0.5,
		_cos = dcos(image_angle), _sin = -dsin(image_angle),
		_wcos = _w * _cos, _wsin = _w * _sin,
		_hcos = _h * _cos, _hsin = _h * _sin,
		_x1 = _x - _wcos + _hsin, _y1 = _y - _wsin - _hcos,
		_x2 = _x + _wcos + _hsin, _y2 = _y + _wsin - _hcos,
		_x3 = _x + _wcos - _hsin, _y3 = _y + _wsin + _hcos,
		_x4 = _x - _wcos - _hsin, _y4 = _y - _wsin + _hcos,
		_depth = shadow_depth, _mag = shadow_mag_depth;
				
	buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);
	buffer_write_shadow_quad(_buff, _x2, _y2, _x3, _y3, _depth, _mag);
	buffer_write_shadow_quad(_buff, _x3, _y3, _x4, _y4, _depth, _mag);
	buffer_write_shadow_quad(_buff, _x4, _y4, _x1, _y1, _depth, _mag);
}