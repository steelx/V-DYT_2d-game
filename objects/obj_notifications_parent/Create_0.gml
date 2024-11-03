/// @description obj_notifications_parent Create Event
surface_width = window_get_width();
surface_height = window_get_height();
alpha = 0;

// Array of messages with timeouts
/*
messages = [
    ["[wave]First notification", 1],
    ["[rainbow]Second notification", 2],
    ["Third notification", 1]
];
*/
messages = [];
active_messages = []; // Stores currently active messages
current_message_index = 0;
_total_messages = 0;

set_messages = function(_messages) {
	messages = _messages;
	_total_messages = array_length(_messages);
	array_push(active_messages, messages[current_message_index][0]);
	alarm[0] = get_room_speed() * messages[current_message_index][1];
};


// Optimization variables
_needs_redraw = false;
_surface = undefined;