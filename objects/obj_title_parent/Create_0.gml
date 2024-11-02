/// @description obj_title Create
surface_width = window_get_width();  // Match viewport width
surface_height = window_get_height(); // Match viewport height
alpha = 0;

// Array of messages with timeouts
messages = [
    ["[wave] Made by Ajinkya", 0.5],
    ["[rainbow] This text will show for half a second", 0.5],
    ["This text will stay for 2 seconds", 2]
];

current_message_index = 0;
message_timer = 0;

typist = scribble_typist();
typist.in(0.1, 0);

// Optimization variables
_needs_redraw = false;
_surface = undefined;
