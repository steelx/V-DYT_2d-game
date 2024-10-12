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