/// @description obj_guardian_enemy Step event
check_animation();
if (!enabled) exit;
if (should_pause_object()) exit;

event_inherited();

var _player_direction = (instance_exists(obj_player)) ? sign(obj_player.x - x) : 0;
var _player_above = instance_exists(obj_player) && obj_player.y < y - sprite_height/2;

switch(state) {
    case CHARACTER_STATE.IDLE:
        vel_x = 0;
        if (!_player_above && (is_player_in_attack_range(attack_range) || is_player_visible(visible_range))) {
            sprite_index = spr_guardian_walk;
            state = CHARACTER_STATE.CHASE;
        } else if (alarm[1] <= 0) {
            // Transition to MOVE based on move_chance
            if (random(1) < move_chance) {
                enemy_random_move_v2(move_speed, 9);
                sprite_index = spr_guardian_walk;
            } else {
                alarm_set(1, roam_timer * choose(2, 3));
            }
        }
        break;

    case CHARACTER_STATE.ATTACK:
        // Attack logic handled by sequence
		start_animation(seq_guardian_attack);
        break;

    case CHARACTER_STATE.MOVE:
        // Check if player is visible during random movement
        if (!_player_above and is_player_visible(visible_range)) {
            state = CHARACTER_STATE.CHASE;
			vel_x = move_speed * (sign(obj_player.x - x));
            last_seen_player_x = obj_player.x;
        }
        break;

    case CHARACTER_STATE.CHASE:
        if (!_player_above && can_attack && is_player_in_attack_range(attack_range)) {
            can_attack = false;
            alarm[4] = attack_delay;
            var _attack_object_x = 40;
            var _attack_object_width = 10;
            if (move_to_attack_position(obj_player.xprevious, _attack_object_x, _attack_object_width)) {
                alarm[3] = 1;
            } else {
                state = CHARACTER_STATE.ATTACK;
            }
			break;
		} else if (!is_player_visible(visible_range)) {
			// Player is out of visible range, transition to ALERT
	        state = CHARACTER_STATE.ALERT;
	        alert_count = alert_count_init;
		}
        break;

    case CHARACTER_STATE.ALERT:
        vel_x = 0;
        sprite_index = spr_guardian_idle;
        
        if (!_player_above and is_player_visible(visible_range)) {
            state = CHARACTER_STATE.CHASE;
            break;
        }
		if (!_player_above and can_attack and is_player_in_attack_range(attack_range)) {
			state = CHARACTER_STATE.ATTACK;
            break;
		}
        
        alert_count--;
        if (alert_count <= 0) {
            state = CHARACTER_STATE.SEARCH;
            search_count = search_count_init;
			search_direction = sign(last_seen_player_x - x);
			search_target_x = last_seen_player_x;
	        image_xscale = search_direction;
			sprite_index = spr_guardian_walk;
        }
        break;

    case CHARACTER_STATE.SEARCH:
		if (!_player_above && is_player_visible(visible_range)) {
	        state = CHARACTER_STATE.CHASE;
	        break;
	    }
    
	    // Initialize search path if empty
	    if (ds_list_empty(search_path_points)) {
	        generate_search_path();
	        current_path_point = 0;
	    }
    
	    var _current_target = search_path_points[|current_path_point];
    
	    // Move towards current search point
	    var _dir_to_point = sign(_current_target - x);
	    var _at_point = abs(x - _current_target) < move_speed;
    
	    if (_at_point) {
	        current_path_point = (current_path_point + 1) % ds_list_size(search_path_points);
	        // Check ground ahead before moving
	        var _valid_ground = check_valid_move(_dir_to_point, 3, global.tile_size);
	        if (_valid_ground == 0) {
	            // No valid ground ahead, switch direction
	            current_path_point = (current_path_point + ceil(ds_list_size(search_path_points)/2)) % ds_list_size(search_path_points);
	        }
	    }
    
	    search_count--;
	    if (search_count <= 0) {
	        alarm_set(1, 1);
	        ds_list_clear(search_path_points);
	        break;
	    }
    
	    // Move safely towards the target point
	    enemy_move_to(_current_target, move_speed);
}

apply_horizontal_movement();
apply_verticle_movement();

if (!is_on_ground()) {
    vel_y += grav_speed;
}
