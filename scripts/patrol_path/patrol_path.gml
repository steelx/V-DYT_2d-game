function PatrolPath() constructor {
    points = ds_list_create();
    current_index = 0;
    return_zone_end = 5;  // Points 0-5 trigger return
    
	static GeneratePoints = function(_start_x, _y, _width, _total_points = 15) {
        ds_list_clear(points);
        var _cell_size = global.collision_grid.cell_size;
        
        // Find initial platform position
        var _platform_y = _y;
        for(var i = -32; i < 32; i++) {
            if (!global.collision_grid.IsValidMove(_start_x, _y + i)) {
                _platform_y = _y + i;
                break;
            }
        }
        
        // Find platform boundaries
        var _platform_left = _start_x;
        var _platform_right = _start_x;
        var _min_clearance = 32; // Minimum vertical clearance needed
        
        // Scan left
        var _check_distance = min(_width / 2, _start_x);
        for(var i = 0; i <= _check_distance; i += _cell_size) {
            var _check_x = _start_x - i;
            
            // Check if we're still on the same platform
            if (global.collision_grid.IsValidMove(_check_x, _platform_y)) {
                break;
            }
            
            // Check vertical clearance
            var _has_clearance = true;
            for(var h = 1; h < _min_clearance; h++) {
                if (!global.collision_grid.IsValidMove(_check_x, _platform_y - h)) {
                    _has_clearance = false;
                    break;
                }
            }
            
            if (!_has_clearance) break;
            _platform_left = _check_x;
        }
        
        // Scan right
        _check_distance = min(_width / 2, room_width - _start_x);
        for(var i = 0; i <= _check_distance; i += _cell_size) {
            var _check_x = _start_x + i;
            
            // Check if we're still on the same platform
            if (global.collision_grid.IsValidMove(_check_x, _platform_y)) {
                break;
            }
            
            // Check vertical clearance
            var _has_clearance = true;
            for(var h = 1; h < _min_clearance; h++) {
                if (!global.collision_grid.IsValidMove(_check_x, _platform_y - h)) {
                    _has_clearance = false;
                    break;
                }
            }
            
            if (!_has_clearance) break;
            _platform_right = _check_x;
        }
        
        // Calculate actual usable width
        var _actual_width = min(_width, _platform_right - _platform_left);
        var _point_count = max(2, floor(_actual_width / (_cell_size * 2))); // Ensure at least 2 points
        var _spacing = _actual_width / (_point_count - 1);
        
        // Generate evenly spaced points
        for(var i = 0; i < _point_count; i++) {
            var _point_x = _platform_left + (i * _spacing);
            
            // Verify final position
            if (global.collision_grid.IsValidMove(_point_x, _platform_y - 1)) {
                continue; // Skip if position is in air
            }
            
            // Add valid point
            ds_list_add(points, {
                x: _point_x,
                y: _platform_y - 1 // Position just above platform
            });
        }
        
        // Ensure minimum viable patrol path
        if (ds_list_size(points) < 2) {
            ds_list_clear(points);
            ds_list_add(points, {
                x: _start_x - (_cell_size * 2),
                y: _platform_y - 1
            });
            ds_list_add(points, {
                x: _start_x + (_cell_size * 2),
                y: _platform_y - 1
            });
        }
        
        // Update return zone
        return_zone_end = min(ds_list_size(points) - 1, floor(ds_list_size(points) * 0.3));
    }
	
	/*
		@desc GetCurrentPoint
		@return _point {x y}
	*/
	static GetCurrentPoint = function() {
	    var _point = ds_list_find_value(points, current_index);
	    return _point;
	}
    
    static IsInReturnZone = function() {
        return (current_index <= return_zone_end);
    }
    
    static MoveToEnd = function() {
        current_index = ds_list_size(points) - 1;
    }
    
    static MoveNext = function() {
        current_index++;
        if (current_index >= ds_list_size(points)) {
            current_index = 0;
        }
    }
    
    static MovePrevious = function() {
        current_index--;
        if (current_index < 0) {
            current_index = ds_list_size(points) - 1;
        }
    }
    
    static DrawPath = function(_y_pos) {
	    var _size = ds_list_size(points);
    
	    // Draw main path
	    for(var i = 0; i < _size - 1; i++) {
	        var _point1 = ds_list_find_value(points, i);
	        var _point2 = ds_list_find_value(points, i + 1);
        
	        // Draw grid validation
	        draw_set_alpha(0.3);
	        var _check_height = 32;
	        draw_rectangle(
	            _point1.x - 2, _point1.y - _check_height,
	            _point1.x + 2, _point1.y + _check_height,
	            true
	        );
        
	        // Draw return path for return zone
	        if (i <= return_zone_end) {
	            var _return_point = ds_list_find_value(points, _size - 1);
	            draw_line_colour(_point1.x, _point1.y, _return_point.x, _return_point.y, c_orange, c_red);
	        }
        
	        draw_line_colour(_point1.x, _point1.y, _point2.x, _point2.y, c_lime, c_green);
	    }
	    draw_set_alpha(1);
	}
    
    static DrawPoints = function(_y_pos, _radius = 0.5) {
        var _size = ds_list_size(points);
        
        for(var i = 0; i < _size; i++) {
            var _point = ds_list_find_value(points, i);
            
            if (i == current_index) {
                draw_set_color(c_red);
                draw_circle(_point, _y_pos, _radius + 0.25, false);
            } else if (i <= return_zone_end) {
                draw_set_color(c_orange);
                draw_circle(_point, _y_pos, _radius, false);
            } else {
                draw_set_color(c_yellow);
                draw_circle(_point, _y_pos, _radius, false);
            }
        }
    }
    
    static Clean = function() {
        ds_list_destroy(points);
    }
}