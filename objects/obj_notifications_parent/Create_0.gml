/// @description obj_notifications_parent Create Event
surface_width = window_get_width();
surface_height = window_get_height();
alpha = 0;

// Array of messages with timeouts
messages = [
    ["[wave]First notification", 1],
    ["[rainbow]Second notification", 2],
    ["Third notification", 1]
];

active_messages = []; // Stores currently active messages
current_message_index = 0;
message_timer = 0;

// set first message as active
set_message_active = function() {
	array_push(active_messages, messages[current_message_index][0]);
};

typist = scribble_typist();
typist.in(1, 0);

// Optimization variables
_needs_redraw = false;
_surface = undefined;