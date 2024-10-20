/// @description obj_tooltip Step
#region Update position
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);

// Check if position needs updating
if (_cam_x != _last_cam_x || _cam_y != _last_cam_y) {
    x = (_init_x - _cam_x) * _viewport_scale_x;
    y = (_init_y - _cam_y) * _viewport_scale_y;

    // Clamp position to stay within surface
    x = clamp(x, 0, surface_width);
    y = clamp(y, 0, surface_height);

    _last_cam_x = _cam_x;
    _last_cam_y = _cam_y;
    _needs_redraw = true;
}

#endregion

// Fade in/out
var _old_alpha = alpha;
alpha = lerp(alpha, target_alpha, fade_speed);

// Check if alpha changed significantly
if (abs(_old_alpha - alpha) > 0.01) {
    _needs_redraw = true;
}

// Check for interaction
if (alpha > 0.5 && (keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(0, gp_face2))) {
    if (interaction_function != undefined && is_callable(interaction_function)) {
        interaction_function();
    }
}

// Destroy if fully faded out
if (alpha < 0.01 && target_alpha == 0) {
    instance_destroy();
}
