/// @description obj_notifications_parent Alarm 0
_needs_redraw = true;
current_message_index += 1;

if current_message_index < _total_messages {
	// set new message as active
	array_push(active_messages, messages[current_message_index][0]);
	alarm[0] = get_room_speed() * messages[current_message_index][1];
}
