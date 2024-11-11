function draw_behavior_tree_debug() {
    var _y_offset = -140;
    var _line_height = 20;
    var _x = x - 100;
    
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    
    var _current_node = bt_root.black_board.running_node ?? bt_root.black_board.root_reference;
    var _node_name = _current_node == noone ? "None" : _current_node.name;
    
    draw_text(_x, y + _y_offset, "Current Node: " + _node_name);
    _y_offset += _line_height;
    
    if (instance_exists(obj_player)) {
        var _dist = distance_to_object(obj_player);
        draw_text(_x, y + _y_offset, "Distance: " + string(_dist));
        _y_offset += _line_height;
        
        draw_text(_x, y + _y_offset, "In Attack Range: " + string(_dist <= attack_range));
        _y_offset += _line_height;
        
        draw_text(_x, y + _y_offset, "Can Attack: " + string(can_attack));
        _y_offset += _line_height;
        
        draw_text(_x, y + _y_offset, "Velocity X: " + string(vel_x));
        _y_offset += _line_height;
        
        // Visual indicators
        draw_set_alpha(0.2);
        draw_circle_color(x, y, visible_range, c_yellow, c_yellow, false);
        draw_circle_color(x, y, attack_range, c_red, c_red, false);
        
        // Draw direction indicators
        draw_arrow(x, y, x + (image_xscale * 32), y, 8);
        draw_set_alpha(1);
    }
}
