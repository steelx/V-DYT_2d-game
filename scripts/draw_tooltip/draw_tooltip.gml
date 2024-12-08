/// @description draw_tooltip Initializes obj_tooltip
/// @param {String} _text The text to display
/// @param {Real} _x The x position relative to the room
/// @param {Real} _y The y position relative to the room
/// @param {Function} _interaction_func The function to call on interaction
/// @return {Id.Instance} return obj_tooltip instance
function draw_tooltip(_text, _x, _y, _interaction_func = undefined, _timeout = noone) {
	var _inst = instance_create_layer(_x, _y, "Instances", obj_tooltip);
    with(_inst) {
		message = _text;
        _init_x = _x;
        _init_y = _y;
        interaction_function = _interaction_func;
        target_alpha = 1;
		if (_timeout != noone and is_numeric(_timeout)) {
			alarm[0] = get_room_speed() * _timeout;
		}
    }
    return _inst;
}

/// @function show_popup_notifications(_messages)
/// @param {Array} _messages Array of message and duration pairs
/**
 @example 
 _messages = [
	[" ", 0.8],
	["[spr_arrow_left] Press Left/Right key for [c_green]movement", 1.2],
	["[spr_arrow_up] Press UP key to [c_blue]jump", 2],
	["[spr_key_space] Press Space key for [c_red]Attack", 2]
 ];
*/
function show_popup_notifications(_messages) {
    with(instance_create_layer(0, 0, "Instances", obj_popup_notifications)) {
        set_messages(_messages);
    }
}
