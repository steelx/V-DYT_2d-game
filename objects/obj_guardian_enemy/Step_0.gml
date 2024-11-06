/// @description obj_guardian_enemy Step event
check_animation();
if !enabled {
	// if attack sequence is running hide this object
	exit;
}

if should_pause_object() {
    event_inherited();
    
    switch(state) {
        case CHARACTER_STATE.IDLE:
            vel_x = 0;
			if (is_player_in_attack_range(attack_range)) {
				alarm_set(1, 1);//MOVE > ATTACK
				break;
			}
            break;
        
        case CHARACTER_STATE.ATTACK:
            vel_x = 0;
            break;
        
        case CHARACTER_STATE.MOVE:
            vel_x = lerp(vel_x, 0, friction_power);
            apply_horizontal_movement();
        
            if (roam_counter > 0) {
				// while moving if player is visible
                roam_counter--;
                if (is_player_in_attack_range(attack_range)) {
					image_xscale = -obj_player.image_xscale;
                    state = CHARACTER_STATE.ATTACK;
                    start_animation(seq_guardian_attack);
                    break;
                } else if (is_player_visible(visible_range)) {
					show_debug_message("player in visible_range");
					// TODO: move towards player
					//break;
				}
            } else {
                roam_counter = roam_counter_init;
                vel_x = 0;
                state = CHARACTER_STATE.IDLE;
                sprite_index = spr_guardian_idle;
                alarm_set(1, roam_timer*choose(2, 3));
            }
            break;
    }
    
    // Apply movement
    apply_verticle_movement();
    
    // Apply gravity
    if (!is_on_ground()) {
        vel_y += grav_speed;
    }

}