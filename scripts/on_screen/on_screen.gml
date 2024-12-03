function toggle_sunrise() {
	with le_day_night_cycle {
		set_sunrise(6, 0.5);
	}
}

/**
 * check whether is given coordinated are in camera view
 * @param {number} _buffer - the offset px number.
 * @returns {bool} Returns true/false
 */
function on_screen(_buffer) {
	var _left = camera_get_view_x(obj_camera.camera) - _buffer;
	var _right = _left + camera_get_view_width(obj_camera.camera) + _buffer;
	var _top = camera_get_view_y(obj_camera.camera) - _buffer;
	var _bottom = _top + camera_get_view_height(obj_camera.camera) + _buffer;
	
	return x > _left and x < _right and y > _top and y < _bottom;
}


#region world to GUI
/**
 * converts a room position to a gui position
 * @param {real} x the x coordinate to convert to gui
 * @param {real} [view] the view number. defaults to 0
 */
function room_x_to_gui(x, view = 0) {
	return (x - camera_get_view_x(view_camera[view])) * (display_get_gui_width() / camera_get_view_width(view_camera[view]));
}
/**
 * converts a room position to a gui position
 * @param {real} y the y coordinate to convert to gui
 * @param {real} [view] the view number. defaults to 0
 */
function room_y_to_gui(y, view = 0) {
	return (y - camera_get_view_y(view_camera[view])) * (display_get_gui_height() / camera_get_view_height(view_camera[view]));
}


/// @function world_to_surface(world_x, world_y, surface_width, surface_height)
/// @param {Real} world_x The x position in world coordinates
/// @param {Real} world_y The y position in world coordinates
/// @param {Real} surface_width Width of the target surface
/// @param {Real} surface_height Height of the target surface
/// @returns {Array<Real>} Array containing [surface_x, surface_y]
function world_to_surface(_world_x, _world_y, _surface_width, _surface_height) {
    // Get current camera properties
    var _cam = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    
    // Calculate viewport to surface scaling
    var _view_w = camera_get_view_width(_cam);
    var _view_h = camera_get_view_height(_cam);
    var _scale_x = _surface_width / _view_w;
    var _scale_y = _surface_height / _view_h;
    
    // Convert world to surface coordinates
    var _surface_x = (_world_x - _cam_x) * _scale_x;
    var _surface_y = (_world_y - _cam_y) * _scale_y;
    
    // Clamp to surface boundaries
    _surface_x = clamp(_surface_x, 0, _surface_width);
    _surface_y = clamp(_surface_y, 0, _surface_height);
    
    return [_surface_x, _surface_y];
}

/* @example
// create event
surface_width = window_get_width();  // Match viewport width
surface_height = window_get_height(); // Match viewport height
gui_surface = surface_create(surface_width, surface_height);
// Draw GUI
gui_surface = draw_to_surface(
    gui_surface,
    surface_width,
    surface_height,
    x,
    y,
    function(_x, _y) {
        bt_root.DrawGUI(_x, _y);
    }
);
*/
/// @param {Id.Surface} surface Surface ID to draw to
/// @param {Real} surface_width Width of the surface
/// @param {Real} surface_height Height of the surface
/// @param {Real} world_x The x position in world coordinates
/// @param {Real} world_y The y position in world coordinates
/// @param {Function} draw_function Function containing draw commands
/// @returns {Id.Surface} Returns surface ID
function draw_to_surface(_surface, _surface_width, _surface_height, _world_x, _world_y, _draw_function) {
    if (!surface_exists(_surface)) {
        _surface = surface_create(_surface_width, _surface_height);
    }
    
    // Set surface as target and clear it
    surface_set_target(_surface);
    draw_clear_alpha(c_black, 0);
    
    // Convert world position to surface coordinates
    var _pos = world_to_surface(_world_x, _world_y, _surface_width, _surface_height);
    
    // Execute drawing function with converted coordinates
    _draw_function(_pos[0], _pos[1]);
    
    surface_reset_target();
    
    // Draw surface stretched to GUI
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    draw_surface_stretched(_surface, 0, 0, _gui_width, _gui_height);
    
    return _surface;
}

#endregion
