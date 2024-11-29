
function ArcPath() constructor {
    points = ds_list_create();
    current_index = 0;
	black_board_ref = noone;
    
	static ValidateEndPosition = function(_start_x, _start_y, _end_x, _end_y) {
        var _inst = black_board_ref.user;
        var _orig_x = _inst.x;
        var _orig_y = _inst.y;
        
        // Function to check if position is valid
        var _check_position = function(_x, _y, _inst) {
            with(_inst) {
                x = _x;
                y = _y;
                
                // Check horizontal clearance only
                if (check_collision(2, 0) ||    // Right
                    check_collision(-2, 0)) {   // Left
                    return false;
                }
                
                // Check for ground below (within reasonable distance)
                var _found_ground = false;
                for(var i = 0; i < 32; i++) {
                    if (check_collision(0, i)) {
                        _found_ground = true;
                        break;
                    }
                }
                
                return _found_ground; // Position is valid if there's ground below
            }
        }
        
        // Check if end position is valid
        var _is_valid = _check_position(_end_x, _end_y, _inst);
        
        // If not valid, try to find a valid position
        if (!_is_valid) {
            var _dir = sign(_end_x - _start_x);
            var _distance = point_distance(_start_x, _start_y, _end_x, _end_y);
            
            // Try decreasing distances until we find a valid spot
            while (_distance > 16) {
                _distance -= 8;
                var _new_end_x = _start_x + (_distance * _dir);
                
                if (_check_position(_new_end_x, _end_y, _inst)) {
                    _end_x = _new_end_x;
                    _is_valid = true;
                    break;
                }
            }
        }
        
        // Restore original position
        _inst.x = _orig_x;
        _inst.y = _orig_y;
        
        // Return validated end position or undefined if no valid position found
        if (_is_valid) {
            return { x: _end_x, y: _end_y };
        }
        return undefined;
    }
	
    static GenerateArc = function(_start_x, _start_y, _end_x, _end_y, _height, _points = 15) {
        ds_list_clear(points);
        
        // Validate end position
        var _valid_end = ValidateEndPosition(_start_x, _start_y, _end_x, _end_y);
        if (_valid_end == undefined) {
            return false; // Could not generate valid path
        }
        
        // Use validated end position
        _end_x = _valid_end.x;
        _end_y = _valid_end.y;
        
        // Calculate arc parameters
        var _distance = point_distance(_start_x, _start_y, _end_x, _end_y);
        
        // Generate points along the arc
        for(var i = 0; i < _points; i++) {
            var _t = i / (_points - 1);  // Time parameter (0 to 1)
            
            // Quadratic bezier curve calculation
            var _inverse_t = 1 - _t;
            
            // Control point (apex of the arc)
            var _control_x = _start_x + (_distance * 0.5);
            var _control_y = min(_start_y, _end_y) - _height;
            
            // Calculate point position
            var _px = power(_inverse_t, 2) * _start_x + 
                     2 * _inverse_t * _t * _control_x + 
                     power(_t, 2) * _end_x;
                     
            var _py = power(_inverse_t, 2) * _start_y + 
                     2 * _inverse_t * _t * _control_y + 
                     power(_t, 2) * _end_y;
            
            ds_list_add(points, {x: _px, y: _py});
        }
        
        return true;
    }
    
    static GetCurrentPoint = function() {
        return ds_list_find_value(points, current_index);
    }
    
    static GetNextPoint = function() {
        var _next_index = current_index + 1;
        if (_next_index >= ds_list_size(points)) return noone;
        return ds_list_find_value(points, _next_index);
    }
    
    static MoveNext = function() {
        current_index++;
        return (current_index < ds_list_size(points));
    }
    
    static DrawPath = function() {
        var _size = ds_list_size(points);
        
        if (_size < 2) return;
        
        for(var i = 0; i < _size - 1; i++) {
            var _point1 = ds_list_find_value(points, i);
            var _point2 = ds_list_find_value(points, i + 1);
            
            draw_line_color(
                _point1.x, _point1.y,
                _point2.x, _point2.y,
                c_yellow, c_yellow
            );
        }
        
        // Draw current point larger
        var _current = ds_list_find_value(points, current_index);
        if (_current != undefined) {
            draw_circle_color(
                _current.x, _current.y,
                0.25, c_red, c_red, false
            );
        }
    }
    
    static Clean = function() {
        ds_list_destroy(points);
    }
}
