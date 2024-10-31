/// Function to draw health in GUI
function draw_player_health(_gui_w, _gui_h, _x, _y, _scale) {
    if (!instance_exists(obj_player)) return;

    var _heart_spacing = 32 * _scale;// Adjust based on heart sprite width
    
    // Draw base heart slots
    for (var _i = 0; _i < obj_player.max_hp; _i++) {
        draw_sprite_ext(spr_red_hearts_4, 3, _x + _i * _heart_spacing, _y, _scale, _scale, 0, c_white, 1);
    }

    // Calculate the index of the most recently damaged/gained heart
    var _damaged_heart_index = floor(obj_player.previous_hp) - 1;
    var _gained_heart_index = floor(obj_player.hp) - 1;
    
    // Draw filled hearts and animations
    for (var _i = 0; _i < obj_player.max_hp; _i++) {
        var _current_hp = obj_player.hp - _i;
        
        if (_current_hp >= 1) {
            // Full heart
            draw_sprite_ext(spr_red_hearts_4, 0, _x + _i * _heart_spacing, _y, _scale, _scale, 0, c_white, 1);
        } else if (_current_hp > 0) {
            // Half heart
            draw_sprite_ext(spr_red_hearts_4, 1, _x + _i * _heart_spacing, _y, _scale, _scale, 0, c_white, 1);
        }
        
        // Damage animation only for the most recently damaged heart
        if (obj_player.hp < obj_player.previous_hp && _i == _damaged_heart_index) {
            var _damage_frame = undefined;
            if (obj_player.no_hurt_frames > 0) {
                // Animate while invincible
                _damage_frame = (current_time / 100) % sprite_get_number(spr_hp_damage);
            } else {
                // Stay on last frame when no longer invincible
                _damage_frame = sprite_get_number(spr_hp_damage) - 1;
            }
            draw_sprite_ext(spr_hp_damage, _damage_frame, _x + _i * _heart_spacing, _y, _scale, _scale, 0, c_white, 1);
        }
        
        // Gain animation, we set hp_gain_animation_active from broadcast event listener
        if (obj_player.hp_gain_animation_active and obj_player.hp > obj_player.previous_hp and _i <= _gained_heart_index and _i > _damaged_heart_index) {
            draw_sprite_ext(spr_hp_gain, (current_time / 100) % sprite_get_number(spr_hp_gain), _x + _i * _heart_spacing, _y, _scale, _scale, 0, c_white, 1);
        }
    }
}
