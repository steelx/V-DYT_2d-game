/// @description Initialize popup notifications
surface_width = window_get_width();
surface_height = window_get_height();
alpha = 0;
messages = [];
current_message_index = 0;
_total_messages = 0;

y_position = surface_height + 50; // Start below screen
target_y = surface_height - 50;   // Target position above bottom
slide_speed = 0.15;
fade_speed = 0.1;
state = "SLIDING_IN";  // States: SLIDING_IN, SHOWING, SLIDING_OUT

// Optimization variables
_needs_redraw = false;
_surface = undefined;

/// Set messages function
set_messages = function(_messages) {
    messages = _messages;
    _total_messages = array_length(_messages);
    // Set first message duration
    alarm[0] = get_room_speed() * messages[current_message_index][1];
}
