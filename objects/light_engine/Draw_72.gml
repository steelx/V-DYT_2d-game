/// @description Update matrix

var _cam		    = camera_get_active(),
	_view_mat	    = camera_get_view_mat(_cam),
	_view_width	    = camera_get_view_width(_cam),
	_view_height    = camera_get_view_height(_cam),
	_view_width_2   = _view_width * 0.5,
	_view_height_2  = _view_height * 0.5,
	_view_cos	    = _view_mat[0],
	_view_sin	    = _view_mat[1],
	_s_width        = surface_get_width(application_surface),
	_s_height       = surface_get_height(application_surface),
	_xscale         = _view_width/_s_width,
	_yscale         = _view_height/_s_height;

view_x         = camera_get_view_x(_cam);
view_y         = camera_get_view_y(_cam);
x              = view_x + _view_width_2; 
y              = view_y + _view_height_2;
image_angle    = -camera_get_view_angle(_cam);
image_xscale   = _xscale;
image_yscale   = _yscale;
surface_width  = _s_width;
surface_height = _s_height;

// Rotated upper left of view
view_x += _view_width_2  - _view_width_2  * _view_cos - _view_height_2 * _view_sin;
view_y += _view_height_2 + _view_width_2  * _view_sin - _view_height_2 * _view_cos;

// Deferred rendering matrix
var _w_xscale = 1/_xscale, _w_yscale = 1/_yscale;
surface_matrix = matrix_build(
	(_view_mat[12] + _view_width_2)  * _w_xscale, 
	(_view_mat[13] + _view_height_2) * _w_yscale, 
	0, 0, 0, -image_angle, _w_xscale, _w_yscale, 1);

// Shadow atlas matrix
_xscale = _view_width/shadow_map_width;
_yscale = _view_height/shadow_map_height;
_w_xscale = 1/_xscale;
_w_yscale = 1/_yscale;
shadow_matrix = matrix_build(
	(_view_mat[12] + _view_width_2)  * _w_xscale, 
	(_view_mat[13] + _view_height_2) * _w_yscale, 
	0, 0, 0, -image_angle, _w_xscale, _w_yscale, 1);