
function ArcPath() constructor {
    points = ds_list_create();
    current_index = 0;
    _inst = noone;
	// is_projectile: don't need the ground validation since arrows should be able to travel through the air
	is_projectile = false;

	static CheckLineOfSight = function(_start_x, _start_y, _end_x, _end_y) {
        var _dir = point_direction(_start_x, _start_y, _end_x, _end_y);
        var _dist = point_distance(_start_x, _start_y, _end_x, _end_y);
        var _step = 16;
        
        with(_inst) {
            var _curr_dist = 0;
            while(_curr_dist < _dist) {
                var _check_x = _start_x + lengthdir_x(_curr_dist, _dir);
                var _check_y = _start_y + lengthdir_y(_curr_dist, _dir);
                
                if (collision_line(_start_x, _start_y, _check_x, _check_y, obj_collision, false, true)) {
                    return false;
                }
                
                _curr_dist += _step;
            }
        }
        return true;
    }
    
    static CalculateProjectileArcHeight = function(_start_x, _start_y, _end_x, _end_y, _base_height) {
        var _distance = point_distance(_start_x, _start_y, _end_x, _end_y);
        var _height = _base_height;
        
        if (!CheckLineOfSight(_start_x, _start_y, _end_x, _end_y)) {
            _height = _distance * 0.6;
            _height = max(_height, 64);
        }
        
        return _height;
    }
    
    static IsPositionValid = function(_x, _y, _inst) {
		// If it's a projectile (like an arrow), we don't need ground validation
        if (is_projectile) return true;

        with(_inst) {
            x = _x;
            y = _y;
            
            // Check horizontal clearance
            if (check_collision(2, 0) || check_collision(-2, 0)) {
                return false;
            }
            
            // Check for ground within range
            return find_ground_below(32);
        }
    }
    
    static FindValidEndPosition = function(_start_x, _start_y, _end_x, _end_y) {
        var _orig_pos = { x: _inst.x, y: _inst.y };
        
        // First try the original end position
        if (IsPositionValid(_end_x, _end_y, _inst)) {
            _inst.x = _orig_pos.x;
            _inst.y = _orig_pos.y;
            return { x: _end_x, y: _end_y };
        }
        
        // If not valid, try finding a closer position
        var _result = FindClosestValidPosition(_start_x, _end_x, _end_y, _inst);
        _inst.x = _orig_pos.x;
        _inst.y = _orig_pos.y;
        
        return _result;
    }
    
    static FindClosestValidPosition = function(_start_x, _end_x, _end_y, _inst) {
        var _dir = sign(_end_x - _start_x);
        var _distance = abs(_end_x - _start_x);
        
        while (_distance > 16) {
            _distance -= 8;
            var _test_x = _start_x + (_distance * _dir);
            
            if (IsPositionValid(_test_x, _end_y, _inst)) {
                return { x: _test_x, y: _end_y };
            }
        }
        
        return undefined;
    }
    
    static GenerateArcPoints = function(_start_x, _start_y, _end_x, _end_y, _height, _points) {
        var _distance = point_distance(_start_x, _start_y, _end_x, _end_y);
        var _control_x = _start_x + (_distance * 0.5);
        var _control_y = min(_start_y, _end_y) - _height;
        
        for(var i = 0; i < _points; i++) {
            var _t = i / (_points - 1);
            var _inverse_t = 1 - _t;
            
            var _point = CalculateBezierPoint(
                _start_x, _start_y,
                _control_x, _control_y,
                _end_x, _end_y,
                _t, _inverse_t
            );
            
            ds_list_add(points, _point);
        }
    }
    
    static CalculateBezierPoint = function(_x1, _y1, _cx, _cy, _x2, _y2, _t, _inv_t) {
        return {
            x: power(_inv_t, 2) * _x1 + 2 * _inv_t * _t * _cx + power(_t, 2) * _x2,
            y: power(_inv_t, 2) * _y1 + 2 * _inv_t * _t * _cy + power(_t, 2) * _y2
        };
    }
    
    static GenerateArc = function(_start_x, _start_y, _end_x, _end_y, _height, _points = 15) {
        ds_list_clear(points);
        
        var _valid_end = FindValidEndPosition(_start_x, _start_y, _end_x, _end_y);
        if (_valid_end == undefined) return false;
        
        var _distance = point_distance(_start_x, _start_y, _valid_end.x, _valid_end.y);
        
        // Apply enhanced arcing only for projectiles
        var _final_height = is_projectile 
            ? CalculateProjectileArcHeight(_start_x, _start_y, _valid_end.x, _valid_end.y, _height)
            : _height;
        
        var _control_x = _start_x + (_distance * 0.5);
        var _control_y = min(_start_y, _valid_end.y) - _final_height;
		
        for(var i = 0; i < _points; i++) {
            var _t = i / (_points - 1);
            var _inverse_t = 1 - _t;
            
            var _px = power(_inverse_t, 2) * _start_x + 
                     2 * _inverse_t * _t * _control_x + 
                     power(_t, 2) * _valid_end.x;
                     
            var _py = power(_inverse_t, 2) * _start_y + 
                     2 * _inverse_t * _t * _control_y + 
                     power(_t, 2) * _valid_end.y;
            
            ds_list_add(points, {x: _px, y: _py});
        }
        
        return true;
    }
	

	/**
	 * Creates a bouncing arc starting from the collision point
	 */
	static GenerateBounceArc = function(_start_x, _start_y, _direction, _force, _height) {
	    ds_list_clear(points);
    
	    // Calculate end point based on bounce angle and force
	    var _bounce_distance = _force * 32; // Reduce distance with each bounce
	    var _end_x = _start_x + lengthdir_x(_bounce_distance, _direction);
	    var _end_y = _start_y;
    
	    // Reduce height with each bounce
	    var _bounce_height = _height * 0.6; // Reduce height by 40%
    
	    // Find valid end position for bounce
	    var _valid_end = FindValidEndPosition(_start_x, _start_y, _end_x, _end_y);
	    if (_valid_end == undefined) return false;
    
	    // Generate arc points for bounce
	    var _distance = point_distance(_start_x, _start_y, _valid_end.x, _valid_end.y);
	    var _control_x = _start_x + (_distance * 0.5);
	    var _control_y = min(_start_y, _valid_end.y) - _bounce_height;
    
	    // Generate fewer points for bounces
	    var _points = 10;
	    for(var i = 0; i < _points; i++) {
	        var _t = i / (_points - 1);
	        var _inverse_t = 1 - _t;
        
	        var _px = power(_inverse_t, 2) * _start_x + 
	                 2 * _inverse_t * _t * _control_x + 
	                 power(_t, 2) * _valid_end.x;
                 
	        var _py = power(_inverse_t, 2) * _start_y + 
	                 2 * _inverse_t * _t * _control_y + 
	                 power(_t, 2) * _valid_end.y;
        
	        // Check for ground collision
	        if (!is_projectile && i > 0) {
	            var _prev_point = ds_list_find_value(points, ds_list_size(points) - 1);
	            if (CheckGroundCollision(_prev_point.x, _prev_point.y, _px, _py)) {
	                // Stop at collision point
	                break;
	            }
	        }
        
	        ds_list_add(points, {x: _px, y: _py});
	    }
    
	    return true;
	}

	/**
	 * Checks for ground collision between two points
	 */
	static CheckGroundCollision = function(_x1, _y1, _x2, _y2) {
	    with(_inst) {
	        var _dir = point_direction(_x1, _y1, _x2, _y2);
	        var _dist = point_distance(_x1, _y1, _x2, _y2);
	        var _step = 4;
        
	        for(var i = 0; i < _dist; i += _step) {
	            var _check_x = _x1 + lengthdir_x(i, _dir);
	            var _check_y = _y1 + lengthdir_y(i, _dir);
            
	            if (check_collision(0, 1)) {
	                return true;
	            }
	        }
	    }
	    return false;
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
