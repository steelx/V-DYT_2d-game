// Replaces the normal light angle functions for directional
update_light_direction    = method(id, light_update_light_directional);
set_angle                 = method(id, light_set_angle_directional);
rotate_angle              = method(id, light_rotate_angle_directional);
set_shadow_length         = method(id, light_set_shadow_length_directional);
increment_shadow_length   = method(id, light_increment_shadow_length_directional);

radius  = max(0, ceil(radius));
width   = max(0, ceil(width));
image_angle = angle_normalize(image_angle);
arc = clamp(arc, 0, 181);
shadow_hardness_value = min(shadow_hardness, 0.999999);
z_depth = floor(z) + light_depth * 0.1;
directional = -1;
params = [image_blend, intensity + floor(light_depth * 1000), falloff, radius + degtorad(image_angle) * 0.1, width + degtorad(arc) * 0.1];
update_light_direction();

// Other light functions
set_z                     = method(id, light_set_z);
increment_z               = method(id, light_increment_z);
set_color                 = method(id, light_set_color);
set_red                   = method(id, light_set_red);
set_green                 = method(id, light_set_green);
set_blue                  = method(id, light_set_blue);
set_intensity             = method(id, light_set_intensity);
increment_intensity       = method(id, light_increment_intensity);
set_depth                 = method(id, light_set_depth);
increment_depth           = method(id, light_increment_depth);
set_falloff               = method(id, light_set_falloff);
increment_falloff         = method(id, light_increment_falloff);
set_radius                = method(id, light_set_radius);
increment_radius          = method(id, light_increment_radius);
set_width                 = method(id, light_set_width);
increment_width           = method(id, light_increment_width);
set_arc                   = method(id, light_set_arc);
increment_arc             = method(id, light_increment_arc);
set_shadow_hardness       = method(id, light_set_shadow_hardness);
increment_shadow_hardness = method(id, light_increment_shadow_hardness);

