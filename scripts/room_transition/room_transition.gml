function goto_room_2() {
	start_room_transition(rm_level_2);
}

function start_room_transition(target_room) {
    with(obj_game) {
        // Only start transition if not already transitioning
        if (!variable_instance_exists(id, "transition_active") || !transition_active) {
            transition_active = true;
            target_room_index = target_room;
            transition_phase = 0; // 0 = fade out, 1 = change room, 2 = fade in
            transition_progress = 0;
            transition_speed = 0.02; // Adjust this value to control transition speed
            
            // Create transition surface if it doesn't exist
            if (!surface_exists(transition_surface)) {
                transition_surface = surface_create(display_get_gui_width(), display_get_gui_height());
            }
        }
    }
}

function draw_diamond_transition() {
    var _w = surface_get_width(transition_surface);
    var _h = surface_get_height(transition_surface);
    var _cx = _w / 2;
    var _cy = _h / 2;
    
    // Calculate diamond points based on progress
    var _size = max(_w, _h) * (transition_phase == 0 ? transition_progress : 1 - transition_progress);
    
    var _points = [
        _cx, _cy - _size, // Top
        _cx + _size, _cy, // Right
        _cx, _cy + _size, // Bottom
        _cx - _size, _cy  // Left
    ];
    
    surface_set_target(transition_surface);
    draw_clear_alpha(c_black, 0);
    
    // Draw black background with diamond-shaped hole
    draw_set_color(c_black);
    draw_set_alpha(1);
    
    // Draw four triangles to create diamond shape
    draw_triangle(0, 0, _points[0], _points[1], _points[6], _points[7], false);
    draw_triangle(_w, 0, _points[0], _points[1], _points[2], _points[3], false);
    draw_triangle(_w, _h, _points[2], _points[3], _points[4], _points[5], false);
    draw_triangle(0, _h, _points[4], _points[5], _points[6], _points[7], false);
    
    surface_reset_target();
}