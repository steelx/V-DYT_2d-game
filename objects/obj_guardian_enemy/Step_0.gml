/// @description obj_guardian_enemy Step event
check_animation();
if !enabled {
	// if attack sequence is running hide this object
	exit;
}

if should_pause_object() {
    event_inherited();
	// moved here to get latest player direction
	var _player_direction = (instance_exists(obj_player)) ? sign(obj_player.x - x) : 0;
	var _player_above = instance_exists(obj_player) && obj_player.y < y - sprite_height/2;
    
    switch(state) {
        case CHARACTER_STATE.IDLE:
            vel_x = 0;
			if ( !_player_above  and (is_player_in_attack_range(attack_range) or is_player_visible(visible_range)) ) {
				sprite_index = spr_guardian_walk;
				state = CHARACTER_STATE.MOVE;
			} else if (roam_counter <= 0) {
                // Transition to MOVE (roam) state if the roam timer is up
				roam_counter = roam_counter_init;
                alarm_set(1, roam_timer * choose(2, 3));
            }
            break;
            
        case CHARACTER_STATE.ATTACK:
            vel_x = 0;
            // Attack logic is handled by the sequence
            break;
            
        case CHARACTER_STATE.MOVE:
            if (!_player_above and can_attack and is_player_in_attack_range(attack_range)) {
				can_attack = false;
				alarm[4] = attack_delay;
				var _attack_object_x = 40; // hammer x away from body
			    var _attack_object_width = 10; // hammer width
    
			    if (move_to_attack_position(obj_player.x, _attack_object_x, _attack_object_width)) {
			        // We moved, so we might want to wait a frame before attacking
			        alarm[3] = 1; // Set an alarm to trigger the attack next frame
			    } else {
			        // We're already in position, attack immediately
			        state = CHARACTER_STATE.ATTACK;
			        start_animation(seq_guardian_attack);
			    }
            } else if (is_player_visible(visible_range)) {
                // Move towards player
                vel_x = _player_direction * move_speed;
                image_xscale = _player_direction;
                sprite_index = spr_guardian_walk;
            } else {
                // Roaming behavior
                if (roam_counter > 0) {
                    roam_counter--;
                } else {
                    state = CHARACTER_STATE.IDLE;
                    sprite_index = spr_guardian_idle;
                    break;
                }
            }
            break;
    }
    
    // Apply movement
	apply_horizontal_movement();
    apply_verticle_movement();
    
    // Apply gravity
    if (!is_on_ground()) {
        vel_y += grav_speed;
    }

}