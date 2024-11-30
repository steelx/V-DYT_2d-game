function PatrolPath() constructor {
    points = ds_list_create();
    current_index = 0;
    return_zone_end = 5;  // Points 0-5 trigger return
    
	static GeneratePoints = function(_start_x, _y, _width, _total_points = 15) {
	    ds_list_clear(points);
	    var _spacing = _width / (_total_points - 1);
	    var _cell_size = global.collision_grid.cell_size;
    
	    // First find the current platform height
	    var _platform_y = _y;
	    for(var i = -32; i < 32; i++) {
	        if (!global.collision_grid.IsValidMove(_start_x, _y + i)) {
	            _platform_y = _y + i;
	            break;
	        }
	    }
    
	    // Generate points along the same height
	    for(var i = 0; i < _total_points; i++) {
	        var _point_x = _start_x + (i * _spacing);
        
	        // Verify point is on the same platform
	        var _valid_point = false;
	        var _check_y = _platform_y;
        
	        // Check if there's ground at this height
	        if (!global.collision_grid.IsValidMove(_point_x, _check_y)) {
	            // Verify there's space above for the character
	            var _has_space = true;
	            for(var h = 1; h < 32; h++) {
	                if (!global.collision_grid.IsValidMove(_point_x, _check_y - h)) {
	                    _has_space = false;
	                    break;
	                }
	            }
            
	            if (_has_space) {
	                _valid_point = true;
	                ds_list_add(points, {
	                    x: _point_x,
	                    y: _check_y - 1 // Position just above the platform
	                });
	            }
	        }
	    }
    
	    // Ensure we have minimum points
	    if (ds_list_size(points) < 2) {
	        ds_list_add(points, {
	            x: _start_x,
	            y: _platform_y - 1
	        });
	    }
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