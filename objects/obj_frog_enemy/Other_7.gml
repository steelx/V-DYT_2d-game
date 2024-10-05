/// @description Frog animation end

if (sprite_index == spr_frog_jump) {
    state = CHARACTER_STATE.MOVE;
    sprite_index = spr_frog_jump_land;
    image_index = 0;
    image_speed = 1;
    exit;
}

if (sprite_index == spr_frog_jump_start) {
    state = CHARACTER_STATE.MOVE;
    vel_y = -15;
    sprite_index = spr_frog_jump;
    image_index = 0;
    image_speed = 1;
    exit;
}

if (sprite_index == spr_frog_jump_land) {
    state = CHARACTER_STATE.IDLE;
    vel_x = 0;
    sprite_index = spr_frog_idle;
    image_index = 0;
    alarm_set(FROG_RESET_JUMP, get_room_speed()); // Reset jump timer
    exit;
}

