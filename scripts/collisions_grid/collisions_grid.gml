/**
 * Creates a grid-based collision detection system for managing obstacles and movement in a room.
 * Is initialized at obj_game room_start as :
 global.collision_grid = new CollisionGrid();
 global.collision_grid.Initialize();
 * @constructor
 * @property {number} cell_size - Size of each grid cell, typically matching tile size.
 * @property {number} grid_width - Number of grid cells horizontally.
 * @property {number} grid_height - Number of grid cells vertically.
 * @property {ds_grid} grid - 2D grid representing walkable/blocked cells.
 * @property {Array} obstacles - Array storing detailed information about collision obstacles.
 */
function CollisionGrid() constructor {
    cell_size = global.tile_size;
    grid_width = room_width div cell_size;
    grid_height = room_height div cell_size;
    grid = ds_grid_create(grid_width, grid_height);
    obstacles = []; // Array for tilemap collisions
    platforms = []; // Array for platform objects (obj_collision instances)

    /**
    * Initializes the collision grid by collecting obstacle and platform information 
    */
    static Initialize = function() {
        obstacles = [];
        platforms = [];

        // First, collect platform information
        with(obj_collision) {
            var _platform = {
                position: { x: x, y: y },
                bbox: {
                    left: bbox_left,
                    right: bbox_right,
                    top: bbox_top,
                    bottom: bbox_bottom
                },
                width: bbox_right - bbox_left,
                height: bbox_bottom - bbox_top,
                instance: id
            };
            array_push(other.platforms, _platform);
        }

        // Then process tilemap collisions
        for(var _x = 0; _x < grid_width; _x++) {
            for(var _y = 0; _y < grid_height; _y++) {
                var _real_x = _x * cell_size;
                var _real_y = _y * cell_size;
                
                // Check tilemap
                var _tile = tilemap_get_at_pixel(global.collision_tilemap, _real_x, _real_y);
                if (_tile != 0) {
                    var _obstacle = {
                        position: { x: _real_x, y: _real_y },
                        bbox: {
                            left: _real_x,
                            right: _real_x + cell_size,
                            top: _real_y,
                            bottom: _real_y + cell_size
                        },
                        grid_pos: { x: _x, y: _y }
                    };
                    array_push(obstacles, _obstacle);
                    grid[# _x, _y] = true;
                } else {
                    grid[# _x, _y] = false;
                }
            }
        }
    }

    /**
    * Checks collision with platforms
    */
    static CheckPlatformCollision = function(_bbox_left, _bbox_right, _bbox_top, _bbox_bottom) {
        for(var i = 0; i < array_length(platforms); i++) {
            var _platform = platforms[i];
            if (bbox_overlaps({
                left: _bbox_left,
                right: _bbox_right,
                top: _bbox_top,
                bottom: _bbox_bottom
            }, _platform.bbox)) {
                return _platform;
            }
        }
        return noone;
    }

    /**
    * Checks collision with tilemap obstacles
    */
    static CheckObstacleCollision = function(_bbox_left, _bbox_right, _bbox_top, _bbox_bottom) {
        var _left_cell = max(0, floor(_bbox_left / cell_size));
        var _right_cell = min(grid_width - 1, floor(_bbox_right / cell_size));
        var _top_cell = max(0, floor(_bbox_top / cell_size));
        var _bottom_cell = min(grid_height - 1, floor(_bbox_bottom / cell_size));

        for(var _x = _left_cell; _x <= _right_cell; _x++) {
            for(var _y = _top_cell; _y <= _bottom_cell; _y++) {
                if (grid[# _x, _y]) return true;
            }
        }
        return false;
    }

    /**
    * Gets nearest platform below a point
    */
    static GetNearestPlatformBelow = function(_x, _y, _max_dist = 64) {
        var _nearest = noone;
        var _nearest_dist = _max_dist;

        for(var i = 0; i < array_length(platforms); i++) {
            var _platform = platforms[i];
            if (_x >= _platform.bbox.left && _x <= _platform.bbox.right) {
                var _dist = _platform.bbox.top - _y;
                if (_dist > 0 && _dist < _nearest_dist) {
                    _nearest = _platform;
                    _nearest_dist = _dist;
                }
            }
        }
        return _nearest;
    }

    /**
    * Gets nearest obstacle below a point
    */
    static GetNearestObstacleBelow = function(_x, _y, _max_dist = 64) {
        var _cell_x = floor(_x / cell_size);
        var _cell_y = floor(_y / cell_size);
        var _max_cells = ceil(_max_dist / cell_size);

        for(var i = 0; i < _max_cells; i++) {
            var _check_y = _cell_y + i;
            if (_check_y >= grid_height) break;
            
            if (grid[# _cell_x, _check_y]) {
                return {
                    distance: i * cell_size,
                    position: {
                        x: _cell_x * cell_size,
                        y: _check_y * cell_size
                    }
                };
            }
        }
        return noone;
    }
	
	static DrawDebug = function() {
        // Draw tilemap obstacles
        draw_set_alpha(0.3);
        for(var i = 0; i < array_length(obstacles); i++) {
            var _obs = obstacles[i];
            draw_rectangle_color(
                _obs.bbox.left, _obs.bbox.top,
                _obs.bbox.right, _obs.bbox.bottom,
                c_red, c_red, c_red, c_red,
                false
            );
        }

        // Draw platforms
        draw_set_alpha(0.3);
        for(var i = 0; i < array_length(platforms); i++) {
            var _platform = platforms[i];
            draw_rectangle_color(
                _platform.bbox.left, _platform.bbox.top,
                _platform.bbox.right, _platform.bbox.bottom,
                c_blue, c_blue, c_blue, c_blue,
                false
            );
        }
        draw_set_alpha(1);
    }
    
    /**
     * Cleans up the collision grid by destroying the data structure.
     * 
     * Should be called when the collision grid is no longer needed 
     * to prevent memory leaks.
     */
    static Cleanup = function() {
        ds_grid_destroy(grid);
    }
    
    /**
     * Checks if two bounding boxes overlap.
     * 
     * @param {Object} _bbox1 - First bounding box with left, right, top, bottom properties
     * @param {Object} _bbox2 - Second bounding box with left, right, top, bottom properties
     * @returns {boolean} True if bounding boxes overlap, false otherwise
     */
    static bbox_overlaps = function(_bbox1, _bbox2) {
        return !(_bbox1.right < _bbox2.left || 
                _bbox1.left > _bbox2.right || 
                _bbox1.bottom < _bbox2.top || 
                _bbox1.top > _bbox2.bottom);
    }
    
    /**
     * Retrieves the obstacle at a specific position.
     * 
     * @param {number} _x - X-coordinate to check
     * @param {number} _y - Y-coordinate to check
     * @returns {Object|noone} The obstacle at the given position, or noone if no obstacle found
     */
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
    
    /**
     * Checks if a specific grid position is valid (walkable) for movement.
     * 
     * @param {number} _x - X-coordinate to validate
     * @param {number} _y - Y-coordinate to validate
     * @returns {boolean} True if the position is valid for movement, false otherwise
     */
    static IsValidMove = function(_x, _y) {
        var _grid_x = _x div cell_size;
        var _grid_y = _y div cell_size;
        
        if (_grid_x < 0 || _grid_x >= grid_width || 
            _grid_y < 0 || _grid_y >= grid_height) {
            return false;
        }
        
        return !grid[# _grid_x, _grid_y];
    }
    
    /**
     * Determines if a jump is possible between start and end positions.
     * 
     * @param {number} _start_x - Starting x-coordinate
     * @param {number} _start_y - Starting y-coordinate
     * @param {number} _end_x - Ending x-coordinate
     * @param {number} _end_y - Ending y-coordinate
     * @returns {boolean} True if the jump is possible, false otherwise
     */
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
    
    /**
     * Checks if movement is safe for a given instance in a specific direction.
     * 
     * @param {Id.Instance} _inst_id - Instance to check movement safety for
     * @param {number} _dir - Direction of movement (1 for right, -1 for left)
     * @returns {boolean} True if movement is safe, false otherwise
     */
    static IsMovementSafe = function(_inst_id, _dir) {
        with(_inst_id) {
            var _check_dist = 16;
            var _check_x = x + (_dir * _check_dist);
            var _ground_check_distance = 32;
            
            // Check for walls
            if (check_collision(_dir * _check_dist, 0)) {
                return false;
            }
            
            // Check for ground continuation
            var _found_ground = false;
            for(var i = 0; i < _ground_check_distance; i++) {
                if (!other.IsValidMove(_check_x, y + i)) {
                    _found_ground = true;
                    break;
                }
            }
            
            return _found_ground;
        }
    }
    
    /**
     * Checks if a path between the current position and target is clear.
     * 
     * @param {Id.Instance} _inst_id - Instance attempting to move
     * @param {number} _target_x - Target x-coordinate
     * @param {number} _target_y - Target y-coordinate
     * @returns {boolean} True if the path is clear, false otherwise
     */
    static IsPathClear = function(_inst_id, _target_x, _target_y) {
        with(_inst_id) {
            var _step_size = global.tile_size;
            var _direction = sign(_target_x - x);
            var _current_x = x;
            var _max_steps = ceil(abs(_target_x - x) / _step_size);
            var _vertical_check_range = 32;
            
            // Check path in steps
            for(var i = 0; i < _max_steps; i++) {
                var _check_x = _current_x + (_step_size * _direction);
                
                // Check for vertical obstacles
                var _has_valid_path = false;
                for(var h = -_vertical_check_range; h < _vertical_check_range; h++) {
                    if (other.IsValidMove(_check_x, y + h)) {
                        _has_valid_path = true;
                        break;
                    }
                }
                
                if (!_has_valid_path) return false;
                
                // Check for ground
                var _found_ground = false;
                for(var g = 0; g < _vertical_check_range; g++) {
                    if (!other.IsValidMove(_check_x, y + g)) {
                        _found_ground = true;
                        break;
                    }
                }
                
                if (!_found_ground) return false;
                _current_x = _check_x;
            }
            
            return true;
        }
    }
    
    /**
     * Determines if a target position is reachable by the instance.
     * 
     * @param {Id.Instance} _inst_id - Instance attempting to reach the target
     * @param {number} _target_x - Target x-coordinate
     * @param {number} _target_y - Target y-coordinate
     * @returns {boolean} True if the target is reachable, false otherwise
     */
    static IsPositionReachable = function(_inst_id, _target_x, _target_y) {
        with(_inst_id) {
            var _max_reachable_height = 16;
            var _vertical_diff = _target_y - y;
            
            // Check if target is within reachable height
            if (abs(_vertical_diff) > _max_reachable_height) {
                return false;
            }
            
            // Check path to target
            var _step_size = 16;
            var _direction = sign(_target_x - x);
            var _current_x = x;
            
            while (abs(_target_x - _current_x) > _step_size) {
                var _next_x = _current_x + (_step_size * _direction);
                
                // Check for obstacles and valid path
                var _found_valid_path = false;
                var _found_ground = false;
                
                // Check for valid path at various heights
                for(var h = -_max_reachable_height; h <= _max_reachable_height; h++) {
                    if (other.IsValidMove(_next_x, y + h)) {
                        _found_valid_path = true;
                        
                        // Check for ground below this position
                        for(var g = 1; g <= _max_reachable_height; g++) {
                            if (!other.IsValidMove(_next_x, y + h + g)) {
                                _found_ground = true;
                                break;
                            }
                        }
                        
                        if (_found_ground) break;
                    }
                }
                
                if (!_found_valid_path || !_found_ground) {
                    return false;
                }
                
                _current_x = _next_x;
            }
            
            return true;
		}
    }
    
    /**
     * Checks if there is an obstacle directly in front of the instance.
     * 
     * @param {Id.Instance} _inst_id - Instance to check for obstacles
     * @param {number} _move_dir - Direction of movement (1 for right, -1 for left)
     * @returns {boolean} True if an obstacle is detected, false otherwise
     */
    static IsObstacleAhead = function(_inst_id, _move_dir) {
        with(_inst_id) {
            var _check_dist = global.tile_size;
            var _check_x = x + (_move_dir * _check_dist);
            
            // Iterate through stored obstacles
            for(var i = 0; i < array_length(other.obstacles); i++) {
                var _obs = other.obstacles[i];
                
                // Check if the check point is within the obstacle's bounding box
                if (_check_x >= _obs.bbox.left && _check_x <= _obs.bbox.right &&
                    y >= _obs.bbox.top && y <= _obs.bbox.bottom) {
                    return true;
                }
            }
            
            return false;
        }
    }
}
