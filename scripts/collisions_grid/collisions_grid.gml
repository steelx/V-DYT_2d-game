function CollisionGrid() constructor {
    cell_size = global.tile_size;
    grid_width = room_width div cell_size;
    grid_height = room_height div cell_size;
    grid = ds_grid_create(grid_width, grid_height);
    obstacles = []; // Array to store obstacle information as structs
    
    static Initialize = function() {
        obstacles = [];
        
        // Collect obstacle information
        with(obj_collision) {
            var _obstacle = {
                position: { x: x, y: y },
                bbox: {
                    left: bbox_left,
                    right: bbox_right,
                    top: bbox_top,
                    bottom: bbox_bottom
                },
                width: bbox_right - bbox_left,
                height: bbox_bottom - bbox_top,
                grid_bounds: {
                    left: bbox_left div other.cell_size,
                    right: bbox_right div other.cell_size,
                    top: bbox_top div other.cell_size,
                    bottom: bbox_bottom div other.cell_size
                }
            };
            array_push(other.obstacles, _obstacle);
        }
        
        // Initialize collision grid
        for(var _x = 0; _x < grid_width; _x++) {
            for(var _y = 0; _y < grid_height; _y++) {
                var _real_x = _x * cell_size;
                var _real_y = _y * cell_size;
                var _cell_bbox = {
                    left: _real_x,
                    right: _real_x + cell_size,
                    top: _real_y,
                    bottom: _real_y + cell_size
                };
                
                grid[# _x, _y] = false;
                
                // Check for obstacle collision with this cell
                for(var i = 0; i < array_length(obstacles); i++) {
                    if (bbox_overlaps(_cell_bbox, obstacles[i].bbox)) {
                        grid[# _x, _y] = true;
                        break;
                    }
                }
                
                // Check tilemap if no obstacle was found
                if (!grid[# _x, _y]) {
                    var _tile = tilemap_get_at_pixel(global.collision_tilemap, _real_x, _real_y);
                    grid[# _x, _y] = (_tile != 0);
                }
            }
        }
    }
    
    static bbox_overlaps = function(_bbox1, _bbox2) {
        return !(_bbox1.right < _bbox2.left || 
                _bbox1.left > _bbox2.right || 
                _bbox1.bottom < _bbox2.top || 
                _bbox1.top > _bbox2.bottom);
    }
    
    static GetObstacleAtPosition = function(_x, _y) {
        for(var i = 0; i < array_length(obstacles); i++) {
            var _obs = obstacles[i];
            if (_x >= _obs.bbox.left && _x <= _obs.bbox.right &&
                _y >= _obs.bbox.top && _y <= _obs.bbox.bottom) {
                return _obs;
            }
        }
        return noone;
    }
    
    static IsValidMove = function(_x, _y) {
        var _grid_x = _x div cell_size;
        var _grid_y = _y div cell_size;
        
        if (_grid_x < 0 || _grid_x >= grid_width || 
            _grid_y < 0 || _grid_y >= grid_height) {
            return false;
        }
        
        return !grid[# _grid_x, _grid_y];
    }
    
	static CanJumpTo = function(_start_x, _start_y, _end_x, _end_y) {
        var _start_cell_x = _start_x div cell_size;
        var _start_cell_y = _start_y div cell_size;
        var _end_cell_x = _end_x div cell_size;
        
        // Calculate horizontal direction and distance
        var _direction = sign(_end_cell_x - _start_cell_x);
        var _dist = abs(_end_cell_x - _start_cell_x);
        var _max_jumpable_height = 4; // Maximum jumpable height in cells
        
        // Check for immediate obstacles in path
        for(var i = 0; i < array_length(obstacles); i++) {
            var _obs = obstacles[i];
            var _obs_cell_height = _obs.height div cell_size;
            
            // Check if obstacle is in the path
            if ((_direction > 0 && 
                 _obs.position.x > _start_x && 
                 _obs.position.x < _start_x + (_dist * cell_size)) ||
                (_direction < 0 && 
                 _obs.position.x < _start_x && 
                 _obs.position.x > _start_x - (_dist * cell_size))) {
                
                // If obstacle is jumpable
                if (_obs_cell_height <= _max_jumpable_height) {
                    return true;
                }
            }
        }
        
        // Fallback to grid check for tiles
        for(var i = 1; i <= _dist; i++) {
            var _check_x = _start_cell_x + (i * _direction);
            if (_check_x < 0 || _check_x >= grid_width) continue;
            
            // Check for obstacles in grid
            if (grid[# _check_x, _start_cell_y]) {
                return true;
            }
        }
        
        return false;
    }
    
    static DrawGrid = function() {
        // Draw base grid
        draw_set_alpha(0.3);
        for(var _x = 0; _x < grid_width; _x++) {
            for(var _y = 0; _y < grid_height; _y++) {
                var _real_x = _x * cell_size;
                var _real_y = _y * cell_size;
                
                if (grid[# _x, _y]) {
                    draw_rectangle_color(
                        _real_x, _real_y,
                        _real_x + cell_size, _real_y + cell_size,
                        c_red, c_red, c_red, c_red,
                        false
                    );
                }
                
                // Grid lines
                draw_rectangle_color(
                    _real_x, _real_y,
                    _real_x + cell_size, _real_y + cell_size,
                    c_yellow, c_yellow, c_yellow, c_yellow,
                    true
                );
            }
        }
        
        // Draw obstacles with their dimensions
        draw_set_color(c_white);
        draw_set_alpha(0.8);
        for(var i = 0; i < array_length(obstacles); i++) {
            var _obs = obstacles[i];
            
            // Draw obstacle bounds
            draw_rectangle(
                _obs.bbox.left, _obs.bbox.top,
                _obs.bbox.right, _obs.bbox.bottom,
                true
            );
            
            // Draw dimensions
            draw_text(
                _obs.bbox.left, _obs.bbox.top - 10,
                string(_obs.width) + "x" + string(_obs.height)
            );
        }
        
        draw_set_alpha(1);
    }
    
    static Cleanup = function() {
        ds_grid_destroy(grid);
    }
}
