/// @description camera Step
// Safety check for room transition
if (!instance_exists(follow) || !room_exists(room)) exit;

// Follow object smoothly with vertical offset
if (follow != noone && instance_exists(follow)) {
    // Smoothly transition between vertical offsets
    if (variable_instance_exists(id, "target_vertical_offset")) {
        current_vertical_offset = lerp(current_vertical_offset, target_vertical_offset, vertical_offset_transition_speed);
    }
    
    // Calculate target position with current vertical offset
    var _target_y = follow.y - current_vertical_offset;
    
    // Smooth movement to target
    move_to_x = follow.x;
    move_to_y = _target_y;
    
    // Ensure target positions are within room bounds
    move_to_x = clamp(move_to_x, _base_w/2, room_width - _base_w/2);
    move_to_y = clamp(move_to_y, _base_h/2, room_height - _base_h/2);
}

// Apply smooth movement with bounds checking
x = lerp(x, move_to_x, camera_pan_speed);
y = lerp(y, move_to_y, camera_pan_speed);

// Ensure camera position stays within room bounds
x = clamp(x, _base_w/2, room_width - _base_w/2);
y = clamp(y, _base_h/2, room_height - _base_h/2);

var _w = camera_get_view_width(camera);
var _h = camera_get_view_height(camera);

// Calculate camera position with proper centering
var _cam_x = x - (_w / 2);
var _cam_y = y - (_h / 2);

// Clamp to room bounds with adjusted calculations
_cam_x = clamp(_cam_x, 0, max(0, room_width - _w));
_cam_y = clamp(_cam_y, 0, max(0, room_height - _h));

#region Apply zoom
// Calculate target dimensions
var _target_w = _base_w / zoom_level;
var _target_h = _base_h / zoom_level;
var _current_w = camera_get_view_width(camera);
var _current_h = camera_get_view_height(camera);

// Handle zoom motion FX
if (maintain_zoom) {
    zoom_level = maintain_zoom_level;
} else if (zoom_motion_active) {
    zoom_motion_timer++;
    
    if (zoom_motion_timer <= zoom_motion_duration/2) {
        // Zoom in phase
        zoom_level = lerp(zoom_level, zoom_motion_target, zoom_motion_speed);
    } else if (zoom_motion_timer <= zoom_motion_duration) {
        // Zoom out phase
        zoom_level = lerp(zoom_level, 1, zoom_motion_speed);
    } else {
        // End zoom motion effect
        zoom_motion_active = false;
        zoom_level = 1;
    }
}

// Smoothly interpolate to the target zoom
var _zoom_speed = 0.1;
var _new_w = lerp(_current_w, _target_w, _zoom_speed);
var _new_h = lerp(_current_h, _target_h, _zoom_speed);

// Update camera view size
camera_set_view_size(camera, _new_w, _new_h);
#endregion

// Apply final camera position with screen shake if active
if screen_shake {
    // Calculate shake offsets with vertical bias
    var _horizontal_shake = random_range(-screen_shake_amount, screen_shake_amount) * (1 - screen_shake_vertical_bias);
    var _vertical_shake = random_range(0, screen_shake_amount) * screen_shake_direction;
    
    // Apply camera position with shake
    camera_set_view_pos(camera, 
        _cam_x + _horizontal_shake, 
        _cam_y + _vertical_shake
    );
    
    // Decay the shake amount
    screen_shake_amount = max(0, screen_shake_amount - screen_shake_decay);
    
    // Alternate shake direction for subtle bounce effect
    screen_shake_direction *= -0.95;
} else {
    camera_set_view_pos(camera, _cam_x, _cam_y);
}

// Ensure camera is set
if (view_camera[0] != camera) {
    view_camera[0] = camera;
}

// Background parallax effect
background_parallax_scrolling(camera);
