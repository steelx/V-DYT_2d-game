/// @description obj_spark Draw
gpu_set_blendmode(bm_add);

var _width = 2.5 * alpha;  // Slightly thinner base width
var _points = ds_list_size(trail_positions);

// Draw trail segments
for(var i = 1; i < _points; i++) {
    var _pos_current = trail_positions[| i];
    var _pos_prev = trail_positions[| i-1];
    
    var _progress = i/_points;
    var _segment_alpha = _progress * alpha * 0.8;  // Slightly more transparent
    var _segment_color = merge_color(col_tail, col_head, _progress);
    
    draw_set_alpha(_segment_alpha);
    draw_set_color(_segment_color);
    draw_line_width(
        _pos_prev[0], _pos_prev[1],
        _pos_current[0], _pos_current[1],
        _width * _progress
    );
}

// Enhanced glow effect at the head
draw_set_alpha(alpha * 0.6);
draw_circle_color(x, y, _width * 2.5, col_head, c_black, false);

// Reset drawing state
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);
