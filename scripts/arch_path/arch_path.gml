
function ArchPath() constructor {
    points = ds_list_create();
    current_index = 0;
    
    static GenerateArc = function(_start_x, _start_y, _end_x, _end_y, _height, _points = 15) {
        ds_list_clear(points);
        
        // Calculate arc parameters
        var _distance = point_distance(_start_x, _start_y, _end_x, _end_y);
        var _direction = point_direction(_start_x, _start_y, _end_x, _end_y);
        
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
            
            // Add point as a struct with both x and y
            ds_list_add(points, {x: _px, y: _py});
        }
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
