/// @description obj_character_parent step event
switch(state) {
    case CHARACTER_STATE.IDLE:
        // Idle state behavior
        vel_x = 0;
        break;
    case CHARACTER_STATE.MOVE:
        // Move state behavior
        // The section below handles pixel-perfect collision checking.
        // It does collision checking twice, first on the X axis, and then on the Y axis.
        var _move_count = abs(vel_x);
        var _move_once = sign(vel_x);

        repeat (_move_count)
        {
            var _collision_found = check_collision(_move_once, 0);
            if (!_collision_found)
            {
                x += _move_once;
            }
            else
            {
                vel_x = 0;
                break;
            }
        }
        break;
	case CHARACTER_STATE.JUMP:
        // Jump state behavior
        if (grounded) {
            vel_y = -jump_speed;
            grounded = false;
        }
        // Transition back to MOVE or IDLE state once in the air
        state = (vel_x != 0) ? CHARACTER_STATE.MOVE : CHARACTER_STATE.IDLE;
        break;
	case CHARACTER_STATE.KNOCKBACK:
        // Knockback state behavior
        // The character is unable to control movement in this state
        // Knockback velocity is applied in the collision event and stopped in Alarm 0
        break;
}

// Vertical movement (applies to all states)
var _move_count = abs(vel_y);
var _move_once = sign(vel_y);

repeat (_move_count) {
    var _collision_found = check_collision(0, _move_once);
    if (!_collision_found)
    {
        y += _move_once;
    }
    else
    {
        vel_y = 0;
        break;
    }
}

// Handle invincibility frames
if (no_hurt_frames > 0) {
    no_hurt_frames--;
}
