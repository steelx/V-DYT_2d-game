/// @description obj_guardian_enemy Step event
check_animation();
if (!enabled) exit;
if (should_pause_object()) exit;

event_inherited();

var _player_direction = (instance_exists(obj_player)) ? sign(obj_player.x - x) : 0;
var _player_above = instance_exists(obj_player) && obj_player.y < y - sprite_height/2;

switch(state) {
    case CHARACTER_STATE.IDLE:
        handle_idle_state();
        break;

    case CHARACTER_STATE.ATTACK:
        // Attack logic handled by sequence
		start_animation(seq_guardian_attack);
        break;

    case CHARACTER_STATE.MOVE:
        if (check_player_visibility()) {
            transition_to_chase();
        } else if (!handle_patrol_movement() && abs(vel_x) < 0.1) {
            state = CHARACTER_STATE.IDLE;
            reset_roam_count();
        }
        break;

    case CHARACTER_STATE.CHASE:
		sprite_index = spr_guardian_walk;
		vel_x = move_speed * (sign(obj_player.x - x));
		if (check_player_attackable()) {
            if (perform_attack_sequence()) break;
        } else if (!check_player_visibility()) {
            transition_to_alert();
        }
        break;

    case CHARACTER_STATE.ALERT:
        vel_x = 0;
        sprite_index = spr_guardian_idle;
        
        if (!_player_above and is_player_visible(visible_range)) {
            transition_to_state(CHARACTER_STATE.CHASE);
            break;
        }
		if (!_player_above and can_attack and is_player_in_attack_range(attack_range)) {
			transition_to_state(CHARACTER_STATE.ATTACK);
            break;
		}
        
        // Check if we were recently knocked back and should counter-attack
	    var _was_knocked_back = get_last_state() == CHARACTER_STATE.KNOCKBACK;
	    if (_was_knocked_back && can_attack && is_player_in_attack_range(attack_range)) {
	        transition_to_state(CHARACTER_STATE.ATTACK);
	        break;
	    }
    
	    alert_count--;
	    if (alert_count <= 0) {
	        transition_to_state(CHARACTER_STATE.SEARCH);
	        search_count = search_count_init;
	        search_direction = sign(last_seen_player_x - x);
	        search_target_x = last_seen_player_x;
	        image_xscale = search_direction;
	    }
	    break;

    case CHARACTER_STATE.SEARCH: {
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
	        transition_to_idle();
	        ds_list_clear(search_path_points);
	        break;
	    }
    
	    // Move safely towards the target point
	    enemy_move_to(_current_target, move_speed);
		break;
	}
}

apply_horizontal_movement();
apply_verticle_movement();

if (!is_on_ground()) {
    vel_y += grav_speed;
}
