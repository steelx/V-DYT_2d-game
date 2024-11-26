/// @desc Checks if there's a platform/obstacle that needs to be jumped over
function is_obstacle_ahead() {
    if (!instance_exists(obj_player)) return false;
    
    var _dir = sign(obj_player.x - x);
    var _look_ahead = 32; // Distance to check ahead
    var _check_height = 32; // Height to check for obstacles
    
    // Debug visualization
    draw_set_color(c_yellow);
    draw_rectangle(
        x + (_dir * _look_ahead), y, 
        x + (_dir * (_look_ahead + 16)), y - _check_height, 
        true
    );
    
    // Check for obstacle ahead
    var _obstacle = collision_rectangle(
        x + (_dir * _look_ahead), y,
        x + (_dir * (_look_ahead + 16)), y - _check_height,
        obj_collision,
        false,
        true
    );
    
    if (_obstacle != noone) {
        // Store obstacle information for jumping
        variable_instance_set(id, "obstacle_top", _obstacle.bbox_top);
        variable_instance_set(id, "obstacle_right", _obstacle.bbox_right);
        variable_instance_set(id, "obstacle_left", _obstacle.bbox_left);
        show_debug_message("Obstacle found! Height: " + string(y - _obstacle.bbox_top));
        return true;
    }
    
    return false;
}

function JumpChaseTask(_move_speed, _jump_force) : BTreeLeaf() constructor {
    name = "Jump Chase Task";
    chase_speed = _move_speed;
    jump_force = _jump_force;
    jump_started = false;
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with (_user) {
            var _dir = sign(obj_player.x - x);
            
            // If we're in the air, continue horizontal movement
            if (!is_on_ground()) {
                vel_x = other.chase_speed * _dir;
                image_xscale = _dir;
                sprite_index = sprites_map[$ CHARACTER_STATE.JUMP];
                return BTStates.Running;
            }
            
            // If we're on ground and haven't jumped yet
            if (!other.jump_started && is_on_ground()) {
                // Calculate jump force based on obstacle height
                var _height_diff = y - obstacle_top;
                var _adjusted_force = other.jump_force + (_height_diff * 0.1);
                
                vel_y = -_adjusted_force;
                other.jump_started = true;
                sprite_index = sprites_map[$ CHARACTER_STATE.JUMP];
                show_debug_message("Jumping over obstacle!");
                return BTStates.Running;
            }
            
            // If we completed the jump sequence
            if (is_on_ground() && other.jump_started) {
                show_debug_message("Jump completed!");
                return BTStates.Success;
            }
            
            return BTStates.Running;
        }
    }
}

function CheckForJumpConditionTask() : BTreeLeaf() constructor {
    name = "Check For Jump Condition Task";
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        show_debug_message("Checking for obstacles...");
        
        with(_user) {
            if (!is_on_ground()) return BTStates.Failure;
            
            // Check if there's an obstacle in the path
            if (is_obstacle_ahead()) {
                show_debug_message("Obstacle detected - initiating jump!");
                return BTStates.Success;
            }
        }
        
        return BTStates.Failure;
    }
}

function CheckForJumpConditionTask2() : BTreeLeaf() constructor {
    name = "Check For Jump Condition Task";
    
    static Process = function() {
        var _user = black_board_ref.user;
        if (!instance_exists(obj_player)) return BTStates.Failure;
        
        with(_user) {
            // Only check for jump if we're chasing the player
            if (!player_detected(true)) return BTStates.Failure;
            if (!is_on_ground()) return BTStates.Failure;
            
            // Use the existing can_jump_over function from movement.gml
            if (can_jump_over(48)) { // Increased look ahead distance
                show_debug_message("Jump condition met - obstacle detected!");
                return BTStates.Success;
            }
        }
        
        return BTStates.Failure;
    }
}