event_inherited();

var _spr = sprite_index;

VLEFT  = -sprite_get_xoffset(_spr);
VTOP   = -sprite_get_yoffset(_spr);
VRIGHT = sprite_get_width(_spr) + VLEFT;
VBOT   = sprite_get_height(_spr) + VTOP;

function add_shadow(_buff)
{
	var _depth = shadow_depth,
		_mag   = shadow_mag_depth,
		_cos   =  dcos(image_angle),
		_sin   = -dsin(image_angle),
		_left  = VLEFT  * image_xscale,
		_right = VRIGHT * image_xscale,
		_top   = VTOP   * image_yscale,
		_bot   = VBOT   * image_yscale;
	
	var _x1 = x - _top * _sin,
		_y1 = y + _top * _cos,
		_x2 = x + _right * _cos - _bot * _sin,
		_y2 = y + _right * _sin + _bot * _cos,
		_x3 = x + _left  * _cos - _bot * _sin,
		_y3 = y + _left  * _sin + _bot * _cos;
	
	buffer_write_shadow_quad(_buff, _x1, _y1, _x2, _y2, _depth, _mag);	
	buffer_write_shadow_quad(_buff, _x2, _y2, _x3, _y3, _depth, _mag);	
	buffer_write_shadow_quad(_buff, _x3, _y3, _x1, _y1, _depth, _mag);
	
	if (destroy_on_create) instance_destroy(id);
}