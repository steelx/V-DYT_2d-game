/**
 * check whether is given coordinated are in camera view
 * @param {number} _buffer - the offset px number.
 * @returns {bool} Returns true/false
 */
function on_screen(_buffer) {
	var _left = camera_get_view_x(o_camera.camera) - _buffer;
	var _right = _left + camera_get_view_width(o_camera.camera) + _buffer;
	var _top = camera_get_view_y(o_camera.camera) - _buffer;
	var _bottom = _top + camera_get_view_height(o_camera.camera) + _buffer;
	
	return x > _left and x < _right and y > _top and y < _bottom;
}
