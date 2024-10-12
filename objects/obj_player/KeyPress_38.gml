/// @description UP key press

// Jump/Jetpack action
// Initialize a timer if it doesn't exist
if (!variable_instance_exists(id, "jump_key_held_timer")) {
    jump_key_held_timer = 0;
}

// Reset the timer when the key is first pressed
jump_key_held_timer = 0;

// Set up an alarm to check the hold duration
alarm_set(JET_PACK_JUMP, 1);

// Don't perform any action yet, wait for the alarm to determine if it's a tap or hold
// check ALARM 1 for jump code