/// @description obj_enemy_parent draw

if (no_hurt_frames > 0) {
    // Save the current shader
    var _current_shader = shader_current();
    
    // Apply the blink effect using GPU fog
    gpu_set_fog(true, c_white, 0, 1);
    gpu_set_fog(true, c_white, 3, 3 + 0.01);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
    
    // Restore the previous shader
    shader_set(_current_shader);
} else {
    // Normal draw without effect
    draw_self();
}

// Draw health bar
if instance_exists(obj_player) and distance_to_object(obj_player) < 156 {
    var _bar_width = 16;
    var _bar_height = 1;
    var _bar_x = x - _bar_width / 2;
    var _bar_y = bbox_bottom + 2; // Position it just below the enemy
    draw_health_bar(
        _bar_x, _bar_y, _bar_width, _bar_height,
        hp, max_hp,
        "#FFFFFF", "#242434", "#e01f3f"
    );
    /*
    draw_healthbar(
        _bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height,
        (hp / max_hp) * 100, c_black, c_red, c_lime, 0, true, true
    );
    */
}
