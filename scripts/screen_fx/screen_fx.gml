/**
 * Adds a red faded border shader effect to the screen.
 * @param {Real} _seconds - Duration of the effect in seconds.
 * @param {Real} _intensity - Intensity of the red border effect (0-1).
 */
function add_player_hurt_red(_seconds, _intensity = 0.5) {
    if !instance_exists(obj_player) return;
	
	with (obj_player) {
		red_border_active = true;
        red_border_intensity = _intensity;
        
        // Set timer to disable shader
        var _duration = get_room_speed() * _seconds;
        alarm_set(PLAYER_DISABLE_SHADER, _duration);
    }
}

/**
 * sets screen_shake bool at obj_camera to add a screenshake effect.
 * @param {Real} _seconds - The title of the book.
 * @param {Real} _shake_amount - The author of the book.
 * @example
 * add_screenshake(2, 3);
 */
function add_screenshake(_seconds, _shake_amount = -1) {
	
	with(obj_camera) {
		if _shake_amount == -1 {
			_shake_amount = screen_shake_amount_initial;
		}
		
		screen_shake = true;
		screen_shake_amount = _shake_amount;
		var _duration = get_room_speed() * _seconds;
		alarm_set(CAMERA_SCREEN_SHAKE, _duration);
	}
}

/// @function resize_window(width, height)
/// @param {Real} width The desired window width
/// @param {Real} height The desired window height
function resize_window(_width, _height) {
    with(obj_camera) {
		var _aspect_ratio = _base_w / _base_h;
	    var _new_aspect_ratio = _width / _height;
    
	    if (_new_aspect_ratio >= _aspect_ratio) {
	        var _new_w = _height * _aspect_ratio;
	        var _new_h = _height;
	    } else {
	        var _new_w = _width;
	        var _new_h = _width / _aspect_ratio;
	    }
    
	    window_set_size(_new_w, _new_h);
	    surface_resize(application_surface, _new_w, _new_h);
	    display_set_gui_size(_new_w, _new_h);
    
	    window_center();
	}
}

/// @function set_camera_vertical_ratio
/// @param {Boolean} reverse Whether to use reversed ratio (30:70)
/// @param {Boolean} instant Whether to switch instantly or smooth transition
function set_camera_vertical_ratio(_reverse = false, _instant = false) {
    with(obj_camera) {
        var _target_offset = _reverse ? vertical_offset_reverse : vertical_offset_normal;
        if (_instant) {
            current_vertical_offset = _target_offset;
        } else {
            // Will be smoothly interpolated in Step event
            target_vertical_offset = _target_offset;
        }
    }
}

/// Modify the apply_zoom_motion_fx function in obj_camera
/// @function apply_zoom_motion_fx(duration, zoom_target, maintain)
/// @param {Real} duration Duration of the effect in frames
/// @param {Real} zoom_target Target zoom level (default: 1.5)
/// @param {Boolean} maintain Whether to maintain the zoom level (default: false)
function apply_zoom_motion_fx(_duration, _zoom_target = 1.5, _maintain = false) {
    with (obj_camera) {
        if (_maintain) {
            // Set up maintained zoom
            maintain_zoom = true;
            maintain_zoom_level = _zoom_target;
            zoom_level = _zoom_target;
            zoom_motion_active = false;
        } else {
            // Regular temporary zoom effect
            zoom_motion_active = true;
            zoom_motion_timer = 0;
            zoom_motion_duration = _duration;
            zoom_motion_target = _zoom_target;
        }
    }
}

/// Add this function to obj_camera
/// @function reset_camera_zoom()
function reset_camera_zoom() {
    with (obj_camera) {
        maintain_zoom = false;
        zoom_level = 1;
        zoom_motion_active = false;
    }
}
