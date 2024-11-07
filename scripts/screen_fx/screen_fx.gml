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

/// @function apply_zoom_motion_fx(duration)
/// @param {Real} duration Duration of the stop-motion effect in frames
function apply_zoom_motion_fx(_duration) {
    // Create a temporary object to manage the effect duration
    with (instance_create_layer(0, 0, "Enemies", obj_stop_motion_controller)) {
        frames_left = _duration * get_room_speed();
        alarm[0] = _duration * get_room_speed();// resume game after duration
    }
}
