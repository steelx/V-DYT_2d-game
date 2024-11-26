function PathNode(_x, _y) constructor {
    x = _x;
    y = _y;
    distance = infinity;    
    parent = noone;        
    visited = false;       
}

function PathFinding(_instance_id) constructor {
    grid_size = global.tile_size; // 16px      
    path_points = ds_list_create();
    nodes = ds_grid_create(room_width div grid_size, room_height div grid_size);
    neighbors = ds_priority_create();
    instance_ref = _instance_id;
    
    static GeneratePath = function(_start_x, _start_y, _end_x, _end_y) {
        ds_list_clear(path_points);
        ds_priority_clear(neighbors);
        ResetGrid();
		var _grid_size = grid_size;

        // Find the ground position below the target
        var _ground_end_x = _end_x;
        var _ground_end_y = _end_y;
        
        // Find the closest ground position below the target
        while (_ground_end_y < room_height) {
            with(instance_ref) {
                if(place_meeting(_ground_end_x, _ground_end_y + _grid_size, obj_collision)) {
                    break;
                }
            }
            _ground_end_y += _grid_size;
        }

        // Snap positions to grid
        var _start_grid_x = floor(_start_x / _grid_size);
        var _start_grid_y = floor(_start_y / _grid_size);
        var _end_grid_x = floor(_ground_end_x / _grid_size);
        var _end_grid_y = floor(_ground_end_y / _grid_size);
        
        var _start_node = new PathNode(_start_grid_x * _grid_size, _start_grid_y * _grid_size);
        _start_node.distance = 0;
        ds_grid_set(nodes, _start_grid_x, _start_grid_y, _start_node);
        ds_priority_add(neighbors, _start_node, 0);
        
        // Search directions: Up, Right, Down, Left, and now including diagonals
        var _directions = [
            [1, 0],   // Right (preferred horizontal movement)
            [-1, 0],  // Left (preferred horizontal movement)
            [0, -2],  // Up (jumping, higher cost)
            [0, 1],   // Down (falling)
        ];

        var _direction_costs = [1, 1, 2, 0.5]; // Lower cost for horizontal movement
        
        while (!ds_priority_empty(neighbors)) {
            var _current = ds_priority_delete_min(neighbors);
            if (_current.visited) continue;
            _current.visited = true;

            if (floor(_current.x / _grid_size) == _end_grid_x && 
                floor(_current.y / _grid_size) == _end_grid_y) {
                BuildPath(_current);
                OptimizePath();
                return true;
            }

            for (var i = 0; i < array_length(_directions); i++) {
                var _next_x = _current.x + (_directions[i][0] * _grid_size);
                var _next_y = _current.y + (_directions[i][1] * _grid_size);

                // Prevent excessive vertical movement
                if (_directions[i][1] < 0) { // If moving up
                    var _height_diff = _current.y - _next_y;
                    if (_height_diff > _grid_size * 3) continue; // Limit jump height
                }

                if (!CheckValidPosition(_next_x, _next_y)) continue;
                
                // Check for ground below when moving horizontally
                if (_directions[i][1] == 0) {
                    var _has_ground = false;
                    with(instance_ref) {
                        if(place_meeting(_next_x, _next_y + _grid_size, obj_collision)) {
                            _has_ground = true;
                        }
                    }
                    if (!_has_ground) continue; // Don't path through air
                }
                
                var _next_grid_x = floor(_next_x / _grid_size);
                var _next_grid_y = floor(_next_y / _grid_size);
                var _neighbor = ds_grid_get(nodes, _next_grid_x, _next_grid_y);
                
                if (_neighbor == 0) {
                    _neighbor = new PathNode(_next_x, _next_y);
                    ds_grid_set(nodes, _next_grid_x, _next_grid_y, _neighbor);
                }
                
                if (_neighbor.visited) continue;
                
                var _new_distance = _current.distance + 
                    (CalculateMovementCost(_current, _neighbor) * _direction_costs[i]);
                
                if (_new_distance < _neighbor.distance) {
                    _neighbor.distance = _new_distance;
                    _neighbor.parent = _current;
                    ds_priority_add(neighbors, _neighbor, _new_distance);
                }
            }
        }
        
        return false;
    }
	
	static OptimizePath = function() {
        if (ds_list_size(path_points) < 3) return;
        
        var i = 0;
        while (i < ds_list_size(path_points) - 2) {
            var _point1 = path_points[| i];
            var _point3 = path_points[| i + 2];
            
            // Check if we can safely move directly from point1 to point3
            if (IsPathClear(_point1.x, _point1.y, _point3.x, _point3.y)) {
                ds_list_delete(path_points, i + 1);
                continue;
            }
            i++;
        }
    }
    
    static IsPathClear = function(_start_x, _start_y, _end_x, _end_y) {
        var _steps = 4; // Check multiple points along the path
        for(var i = 0; i <= _steps; i++) {
            var _check_x = lerp(_start_x, _end_x, i/_steps);
            var _check_y = lerp(_start_y, _end_y, i/_steps);
            
            with(instance_ref) {
                if(place_meeting(_check_x, _check_y, obj_collision)) {
                    return false;
                }
            }
        }
        return true;
    }
	
    static CheckValidPosition = function(_check_x, _check_y) {
        if (_check_x < 0 || _check_y < 0 || _check_x >= room_width || _check_y >= room_height) 
            return false;
        
        with(instance_ref) {
            return !check_collision(_check_x - x, _check_y - y);
        }
    }
    
    static CalculateMovementCost = function(_from, _to) {
        return point_distance(_from.x, _from.y, _to.x, _to.y);
    }
    
    static ResetGrid = function() {
        ds_grid_clear(nodes, 0);
    }
    
    static BuildPath = function(_end_node) {
        var _current = _end_node;
        while (_current != noone) {
            ds_list_insert(path_points, 0, {
                x: _current.x + grid_size/2,
                y: _current.y + grid_size/2
            });
            _current = _current.parent;
        }
    }
    
    static DrawPath = function() {
        if (ds_list_empty(path_points)) return;
        
        // Draw grid for visualization (optional)
        draw_set_alpha(0.2);
        for (var i = 0; i < room_width; i += grid_size) {
            for (var j = 0; j < room_height; j += grid_size) {
                draw_rectangle(i, j, i + grid_size, j + grid_size, true);
            }
        }
        draw_set_alpha(1);
        
        // Draw path
        var _size = ds_list_size(path_points);
        for (var i = 0; i < _size - 1; i++) {
            var _point1 = path_points[| i];
            var _point2 = path_points[| i + 1];
            
            draw_line_width_color(
                _point1.x, _point1.y,
                _point2.x, _point2.y,
                2, c_yellow, c_orange
            );
            
            draw_circle_color(
                _point1.x, _point1.y,
                3, c_red, c_red, false
            );
        }
        
        if (_size > 0) {
            var _last = path_points[| _size - 1];
            draw_circle_color(
                _last.x, _last.y,
                3, c_red, c_red, false
            );
        }
    }
    
    static Clean = function() {
        ds_list_destroy(path_points);
        ds_grid_destroy(nodes);
        ds_priority_destroy(neighbors);
    }
}

