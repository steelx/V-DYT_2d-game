function CollisionGrid() constructor {
    cell_size = global.tile_size;
    grid_width = room_width div cell_size;
    grid_height = room_height div cell_size;
    grid = ds_grid_create(grid_width, grid_height);
    obstacle_heights = ds_grid_create(grid_width, grid_height); // Store obstacle heights
    
    static Initialize = function() {
        for(var _x = 0; _x < grid_width; _x++) {
            for(var _y = 0; _y < grid_height; _y++) {
                var _real_x = _x * cell_size;
                var _real_y = _y * cell_size;
                
                var _collision = collision_rectangle(
                    _real_x, _real_y,
                    _real_x + cell_size - 1, _real_y + cell_size - 1,
                    obj_collision,
                    false, true
                );
                
                var _tile = tilemap_get_at_pixel(global.collision_tilemap, _real_x, _real_y);
                
                grid[# _x, _y] = (_collision != noone || _tile != 0);
                
                // Calculate obstacle height
                if (grid[# _x, _y]) {
                    var _height = 1;
                    var _check_y = _y - 1;
                    while(_check_y >= 0) {
                        if (tilemap_get_at_pixel(global.collision_tilemap, _real_x, _check_y * cell_size) ||
                            collision_rectangle(_real_x, _check_y * cell_size, 
                                             _real_x + cell_size - 1, (_check_y + 1) * cell_size - 1,
                                             obj_collision, false, true)) {
                            _height++;
                            _check_y--;
                        } else {
                            break;
                        }
                    }
                    obstacle_heights[# _x, _y] = _height;
                } else {
                    obstacle_heights[# _x, _y] = 0;
                }
            }
        }
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
        var _end_cell_y = _end_y div cell_size;
        
        // Calculate the height difference
        var _height_diff = _end_cell_y - _start_cell_y;
        var _dist = abs(_end_cell_x - _start_cell_x);
        
        // Check if there's an obstacle in between that we can jump over
        var _direction = sign(_end_cell_x - _start_cell_x);
        var _max_height = 4; // Maximum jumpable height in cells
        
        for(var i = 0; i <= _dist; i++) {
            var _check_x = _start_cell_x + (i * _direction);
            if (_check_x < 0 || _check_x >= grid_width) continue;
            
            // Check for obstacles and their heights
            if (grid[# _check_x, _start_cell_y]) {
                var _obstacle_height = obstacle_heights[# _check_x, _start_cell_y];
                if (_obstacle_height <= _max_height) {
                    return true; // We found a jumpable obstacle
                }
            }
        }
        
        return false;
    }
    
    static DrawGrid = function() {
        draw_set_alpha(0.3);
        for(var _x = 0; _x < grid_width; _x++) {
            for(var _y = 0; _y < grid_height; _y++) {
                var _real_x = _x * cell_size;
                var _real_y = _y * cell_size;
                
                if (grid[# _x, _y]) {
                    var _height = obstacle_heights[# _x, _y];
                    var _color = make_color_hsv((_height * 30) % 255, 255, 255);
                    draw_rectangle_color(
                        _real_x, _real_y,
                        _real_x + cell_size, _real_y + cell_size,
                        _color, _color, _color, _color,
                        false
                    );
                }
                
                // Draw grid lines
                draw_rectangle_color(
                    _real_x, _real_y,
                    _real_x + cell_size, _real_y + cell_size,
                    c_yellow, c_yellow, c_yellow, c_yellow,
                    true
                );
            }
        }
        draw_set_alpha(1);
    }
    
    static Cleanup = function() {
        ds_grid_destroy(grid);
        ds_grid_destroy(obstacle_heights);
    }
}
