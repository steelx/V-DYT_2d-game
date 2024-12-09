/// @description Room start

view_camera[0] = camera;
view_enabled = true;
view_visible[0] = true;

// Ensure camera follows player if it exists
if (instance_exists(obj_player)) {
    follow = obj_player;
    // Initialize position with room bounds checking
    x = clamp(obj_player.x, _base_w/2, room_width - _base_w/2);
    y = clamp(obj_player.y - current_vertical_offset, _base_h/2, room_height - _base_h/2);
    move_to_x = x;
    move_to_y = y;
    
    // Update camera view position immediately
    var _cam_x = x - (_base_w / 2);
    var _cam_y = y - (_base_h / 2);
    _cam_x = clamp(_cam_x, 0, max(0, room_width - _base_w));
    _cam_y = clamp(_cam_y, 0, max(0, room_height - _base_h));
    camera_set_view_pos(camera, _cam_x, _cam_y);
}

window_center();
