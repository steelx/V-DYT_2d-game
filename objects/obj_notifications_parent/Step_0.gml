/// @description obj_notifications_parent Step Event
// Fade in/out
var _old_alpha = alpha;
var _fade_speed = 0.1;
alpha = lerp(alpha, 1, _fade_speed);

// Check if alpha changed significantly
if (abs(_old_alpha - alpha) > 0.01) {
    _needs_redraw = true;
}

// Handle message stacking
message_timer += delta_time / 1000000; // Convert to seconds

if (current_message_index < array_length(messages) && 
    message_timer >= messages[current_message_index][1]) {
    set_message_active();
    current_message_index++;
    message_timer = 0;
    typist.reset();
    _needs_redraw = true;
}