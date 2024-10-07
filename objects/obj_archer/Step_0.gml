/// @description obj_archer Step event

event_inherited();

switch(state) {
    case CHARACTER_STATE.IDLE:
        vel_x = 0;
        break;
    
    case CHARACTER_STATE.ATTACK:
        vel_x = 0;
        if (is_animation_end()) {
            if (is_player_in_attack_range(attack_range)) {
                // Reset attack animation
                image_index = 0;
                image_xscale = sign(obj_player.x-x);
            } else {
                state = CHARACTER_STATE.IDLE;
                sprite_index = spr_archer_idle;
                mask_index = spr_archer_idle;
                alarm_set(SLIME_ROAM, roam_timer * 2);
            }
        }
        break;
    
    case CHARACTER_STATE.MOVE:
        vel_x = lerp(vel_x, 0, friction_power);
    
        if (is_animation_end()) {
            if (is_player_in_attack_range(attack_range)) {
                state = CHARACTER_STATE.ATTACK;
                sprite_index = spr_archer_attack;
                break;
            } else {
                vel_x = 0;
                state = CHARACTER_STATE.IDLE;
                sprite_index = spr_archer_idle;
                alarm_set(SLIME_ROAM, roam_timer*choose(1, 2));
            }
        }
    
        apply_horizontal_movement();
        break;
}

// Apply movement
apply_verticle_movement();

// Apply gravity
if (!is_on_ground()) {
    vel_y += grav_speed;
}
