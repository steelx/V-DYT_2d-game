/// @description obj_title_parent Create
/// Added title messages to the center of screen, message and stay duration
/// Array of messages with durations in seconds
/* Usage:
var _messages = [
    ["[wave] Made by Ajinkya", 2],
    ["[rainbow] This text will show for half a second", 3],
    ["This text will stay for 2 seconds", 2]
];
set_messages(_messages);
*/
surface_width = window_get_width();  // Match viewport width
surface_height = window_get_height(); // Match viewport height
alpha = 0;

messages = [];
current_message_index = 0;
_total_messages = array_length(messages);

typist = scribble_typist();
typist.in(0.1, 0);

// Optimization variables
_needs_redraw = false;
_surface = undefined;

set_messages = function(_messages) {
	messages = _messages;
	_total_messages = array_length(_messages);
	alarm[0] = get_room_speed() * _messages[current_message_index][1];
}