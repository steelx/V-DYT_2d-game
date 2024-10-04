/**
 * sets screen_shake bool at obj_camera to add a screenshake effect.
 * @param {Integer} _seconds - The title of the book.
 * @param {Integer} _shake_amount - The author of the book.
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