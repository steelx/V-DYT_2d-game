/// @description FROG_RESET_JUMP
/// jump towards player or jump
if !instance_exists(obj_player) {
    exit;
}

if (state == CHARACTER_STATE.IDLE) {
    // Check if player is in range and jump if so
    if (distance_to_object(obj_player) < jump_range) {
        sprite_index = spr_frog_jump_start;
        image_index = 0;
        image_speed = 1;
    } else {
        // If player is not in range, set alarm to check again
        alarm_set(FROG_RESET_JUMP, get_room_speed());
    }
}
