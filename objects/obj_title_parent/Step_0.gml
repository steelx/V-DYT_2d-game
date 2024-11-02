/// @description obj_title Step

// Fade in/out
var _old_alpha = alpha;
var _fade_speed = 0.1;
alpha = lerp(alpha, 1, _fade_speed);

// Check if alpha changed significantly
if (abs(_old_alpha - alpha) > 0.01) {
    _needs_redraw = true;
}

// Handle message switching
message_timer++;

var _seconds_to_delta = get_room_speed() * messages[current_message_index][1]
if (message_timer >= _seconds_to_delta) {
    current_message_index++;
    message_timer = 0;
    typist.reset();
    
    if (current_message_index >= array_length(messages)) {
        current_message_index = 0; // Loop back to the first message
    }
    
    _needs_redraw = true;
}
