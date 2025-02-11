
#region transition state / parent

function transition_to_chase() {
    transition_to_state(CHARACTER_STATE.CHASE);
    last_seen_player_x = obj_player.x;
}

function transition_to_alert() {
    transition_to_state(CHARACTER_STATE.ALERT);
    alert_count = alert_count_init;
}

function transition_to_idle() {
    transition_to_state(CHARACTER_STATE.IDLE);
}


/// obj enemy parent specific
function get_last_state() {
	return prev_states[0];
}

function update_state_history(_new_state) {
    array_copy(prev_states, 1, prev_states, 0, 2);
    prev_states[0] = state;
}

function transition_to_state(_new_state) {
    update_state_history(_new_state);
    state = _new_state;
    sprite_index = sprites_map[$ _new_state];
}

#endregion

// since now we have seen player, we also have last player x positio info
function perform_attack_sequence(_alarm_index = 4, _alarm_attack_seq = 3) {
    can_attack = false;
    alarm[_alarm_index] = attack_delay;
    var _attack_object_x = 40;
    var _attack_object_width = 10;
    
    if (move_to_attack_position(last_seen_player_x, _attack_object_x, _attack_object_width)) {
        alarm[_alarm_attack_seq] = 1;
        return false;
    }
    
    state = CHARACTER_STATE.ATTACK;
    return true;
}

function handle_patrol_movement() {
    var _distance_from_start = abs(x - xstart);
    if (_distance_from_start > patrol_width) {
        var _return_direction = sign(xstart - x);
        enemy_move_to(xstart, move_speed);
        image_xscale = _return_direction;
        return true;
    }
    return false;
}



function reset_roam_count() {
    roam_count = roam_count_max * choose(2, 3);
}

function handle_idle_state(_sprite_idle = spr_guardian_idle) {
    vel_x = 0;
    sprite_index = _sprite_idle;
    
    if (check_player_visibility()) {
		alarm_set(1, 1);//play move sound
        transition_to_chase();
        return;
    }
    
    if (roam_count > 0) {
        roam_count--;
    }
    
    if (roam_count <= 0) {
        if (random(1) < move_chance) {
			alarm_set(1, 1);//play move sound
            state = CHARACTER_STATE.MOVE;
            enemy_random_move_v2(move_speed, 9);
            sprite_index = spr_guardian_walk;
        } else {
            reset_roam_count();
        }
    }
}
