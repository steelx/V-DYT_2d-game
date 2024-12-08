/// @description Handle notification states
switch(state) {
    case "SLIDING_IN":
        alpha = lerp(alpha, 1, fade_speed);
        y_position = lerp(y_position, target_y, slide_speed);
        
        if (abs(y_position - target_y) < 1) {
            state = "SHOWING";
        }
        break;
        
    case "SHOWING":
        // Wait for alarm
        break;
        
    case "SLIDING_OUT":
        y_position = lerp(y_position, surface_height + 50, slide_speed);
        
        if (abs(y_position - (surface_height + 50)) < 1) {
            if (current_message_index < _total_messages - 1) {
                // More messages to show
                current_message_index++;
                y_position = surface_height + 50;
                state = "SLIDING_IN";
                alarm[0] = get_room_speed() * messages[current_message_index][1];
            } else {
                // No more messages, fade out
                alpha = lerp(alpha, 0, fade_speed);
                if (alpha < 0.01) {
                    instance_destroy();
                }
            }
        }
        break;
}

_needs_redraw = true;
