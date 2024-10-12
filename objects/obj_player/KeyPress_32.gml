/// @description Space key press

// Initialize a timer if it doesn't exist
if (!variable_instance_exists(id, "space_hold_timer")) {
    space_hold_timer = 0;
}

// Reset the timer when the key is first pressed
space_hold_timer = 0;

// Set up an alarm to check the hold duration
alarm_set(JET_PACK_JUMP, 1);

// Don't perform any action yet, wait for the alarm to determine if it's a tap or hold
// check ALARM 1 for jump code
