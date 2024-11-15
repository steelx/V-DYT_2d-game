function PatrolPath() constructor {
    points = ds_list_create();
    current_index = 0;
    return_zone_end = 5;  // Points 0-5 trigger return
    
    static GeneratePoints = function(_start_x, _width, _total_points = 15) {
        ds_list_clear(points);
        var _spacing = _width / (_total_points - 1);
        
        for(var i = 0; i < _total_points; i++) {
            ds_list_add(points, _start_x + (i * _spacing));
        }
    }
    
    static GetCurrentPoint = function() {
        return ds_list_find_value(points, current_index);
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
            
            // Draw return path for return zone
            if (i <= return_zone_end) {
                var _return_point = ds_list_find_value(points, _size - 1);
                draw_line_colour(_point1, _y_pos, _return_point, _y_pos, c_orange, c_red);
            }
            
            draw_line_colour(_point1, _y_pos, _point2, _y_pos, c_lime, c_green);
        }
    }
    
    static DrawPoints = function(_y_pos, _radius = 1) {
        var _size = ds_list_size(points);
        
        for(var i = 0; i < _size; i++) {
            var _point = ds_list_find_value(points, i);
            
            if (i == current_index) {
                draw_set_color(c_red);
                draw_circle(_point, _y_pos, _radius + 2, false);
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