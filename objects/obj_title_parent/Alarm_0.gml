/// @description obj_title_parent Alarm 0
current_message_index++;
_needs_redraw = true;

if (current_message_index >= _total_messages) {
	current_message_index = _total_messages-1;
    exit;
}

// Set alarm for next message
alarm[0] = get_room_speed() * messages[current_message_index][1];
