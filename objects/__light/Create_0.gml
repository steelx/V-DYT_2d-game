radius  = max(0, ceil(radius));
width   = max(0, ceil(width));
image_angle = angle_normalize(image_angle);
arc = clamp(arc, 0, 181);
shadow_hardness_value = min(shadow_hardness, 0.999999);
z_depth = floor(z) + light_depth * 0.1;
directional = 1;

params = [image_blend, intensity + floor(light_depth * 1000), falloff, radius + degtorad(image_angle) * 0.1, width + degtorad(arc) * 0.1];

/**** Light Parameters ****

	Light color: Uses image_blend which packs RGB into 24 bit integer
	
	Intensity: Normalized from 0 to 1
	
	Falloff and index: Normalized from -1 to 1
	
	Radius and angle: The light radius and angle (or direction) are packed into the same float where
	the whole number portion is the radius and angle (in radians) is packed into the decimal portion
	after shifting the decimal.
	
	Width and arc: Packed into a single float with width (line light) using the whole number portion and
	the arc (in radians) packed into the decimal portion after shifting it one place.
	
	Shadow hardness: When using soft-shadows it will influence how hard or soft the edge is range 0 to 1
*/

enum e_light
{
	color,
	intensity_depth,
	falloff,
	radius_angle,
	width_arc
}

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
set_angle                 = method(id, light_set_angle);
rotate_angle              = method(id, light_rotate_angle);
set_width                 = method(id, light_set_width);
increment_width           = method(id, light_increment_width);
set_arc                   = method(id, light_set_arc);
increment_arc             = method(id, light_increment_arc);
set_shadow_hardness       = method(id, light_set_shadow_hardness);
increment_shadow_hardness = method(id, light_increment_shadow_hardness);