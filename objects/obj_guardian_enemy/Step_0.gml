/// @description obj_guardian_enemy Step event
check_animation();
if !enabled {
    // If attack sequence is running, hide this object
    exit;
}

if should_pause_object() {
    exit;
}

event_inherited();

// Get latest player direction and position
var _player_direction = (instance_exists(obj_player)) ? sign(obj_player.x - x) : 0;
var _player_above = instance_exists(obj_player) && obj_player.y < y - sprite_height/2;

switch(state) {
    case CHARACTER_STATE.IDLE:
        vel_x = 0;
        if (!_player_above && (is_player_in_attack_range(attack_range) || is_player_visible(visible_range))) {
            sprite_index = spr_guardian_walk;
			state = CHARACTER_STATE.MOVE;
        } else if (alarm[1] <= 0) {
            // Set roam timer if alarm is not active
            alarm_set(1, roam_timer * choose(2, 3));
        }
        break;

    case CHARACTER_STATE.ATTACK:
        vel_x = 0;
        // Attack logic is handled by the sequence
        break;

    case CHARACTER_STATE.MOVE:
        if (!_player_above && can_attack && is_player_in_attack_range(attack_range)) {
            can_attack = false;
            alarm[4] = attack_delay;
            var _attack_object_x = 40; // Hammer x away from body
            var _attack_object_width = 10; // Hammer width
            if (move_to_attack_position(obj_player.xprevious, _attack_object_x, _attack_object_width)) {
                alarm[3] = 1; // Set an alarm to trigger the attack next frame
            } else {
                state = CHARACTER_STATE.ATTACK;
                start_animation(seq_guardian_attack);
            }
        } else if (is_player_visible(visible_range)) {
			// Move towards player
            last_seen_player_x = obj_player.x;
            vel_x = _player_direction * move_speed;
			sprite_index = spr_guardian_idle;
			image_xscale = _player_direction;
        } else if (alarm[1] <= 0) {
            // If not moving and alarm is not set, go back to IDLE
            state = CHARACTER_STATE.IDLE;
            sprite_index = spr_guardian_idle;
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
