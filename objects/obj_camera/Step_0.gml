/// @description camera Step
// 1. set viewport position
x = lerp(x, move_to_x, camera_pan_speed);
y = lerp(y, move_to_y, camera_pan_speed);

var _w = camera_get_view_width(camera);
var _h = camera_get_view_height(camera);

var _center_x = x - _w/2;
var _center_y = y - _h/2;
camera_set_view_pos(camera, _center_x, _center_y);

// 2. follow camera
if (follow != noone and instance_exists(follow)) {
    move_to_x = follow.x;
    move_to_y = follow.y - global.tile_size/2;
}

#region Apply zoom
// Calculate target dimensions
var _target_w = _base_w / zoom_level;
var _target_h = _base_h / zoom_level;

var _current_w = camera_get_view_width(camera);
var _current_h = camera_get_view_height(camera);

// Smoothly interpolate to the target zoom
var _zoom_speed = 0.1; // Adjust this value to change zoom speed
var _new_w = lerp(_current_w, _target_w, _zoom_speed);
var _new_h = lerp(_current_h, _target_h, _zoom_speed);

// Update camera view size
camera_set_view_size(camera, _new_w, _new_h);

// Adjust camera position to keep it centered on the follow object
if (follow != noone && instance_exists(follow)) {
    var _new_x = follow.x - _new_w / 2;
    var _new_y = follow.y - _new_h / 2;
    camera_set_view_pos(camera, _new_x, _new_y);
} else {
    // If no follow object, center on current position
    var _new_x = x - _new_w / 2;
    var _new_y = y - _new_h / 2;
    camera_set_view_pos(camera, _new_x, _new_y);
}

// Recalculate variables for other operations
_w = camera_get_view_width(camera);
_h = camera_get_view_height(camera);
_center_x = camera_get_view_x(camera) + _w / 2;
_center_y = camera_get_view_y(camera) + _h / 2;
#endregion

// limit camera movement within room width & height
var _xx = clamp(camera_get_view_x(camera), 0, room_width - _w);
var _yy = clamp(camera_get_view_y(camera), 0, room_height - _h);

if screen_shake {
	// Generate random offset for shake
    var _shake_x = choose(-screen_shake_amount, screen_shake_amount);
    var _shake_y = choose(-screen_shake_amount, screen_shake_amount);
	
	var _curr_x = camera_get_view_x(camera);
	var _curr_y = camera_get_view_y(camera);
	var _spd = 0.1;
	
	// Apply offset to camera position
    camera_set_view_pos(camera, lerp(_curr_x, _xx, _spd) + _shake_x, lerp(_curr_y, _yy, _spd) + _shake_y);
} else {
	camera_set_view_pos(camera, _xx, _yy);
}

// BG scroll effect
background_parallax_scrolling(camera);
