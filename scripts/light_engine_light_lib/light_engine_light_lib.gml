// **** Z height **** //
function light_set_z(_z)
{
	z = clamp(_z, 1, LE_LIGHT_MAX_RANGE);
	z_depth = floor(z) + light_depth * 0.1;
}

function light_increment_z(_increment)
{
	z = clamp(z + _increment, 1, LE_LIGHT_MAX_RANGE);
	z_depth = floor(z) + light_depth * 0.1;
}

// **** Color **** //
function light_set_color(_color)
{
	image_blend = _color;
	params[e_light.color] = _color;
}

function light_set_red(_red)
{
	set_color(make_color_rgb(_red, color_get_green(image_blend), color_get_blue(image_blend)));
}

function light_set_green(_green)
{
	set_color(make_color_rgb(color_get_red(image_blend), _green, color_get_blue(image_blend)));
}

function light_set_blue(_blue)
{
	set_color(make_color_rgb(color_get_red(image_blend), color_get_green(image_blend), _blue));
}

// **** Intensity **** //
function light_set_intensity(_intensity)
{
	intensity = clamp(_intensity, 0, 0.98);
	params[e_light.intensity_depth] = intensity + floor(light_depth * 1000);
}

function light_increment_intensity(_increment)
{
	intensity = clamp(intensity + _increment, 0, 0.98);
	params[e_light.intensity_depth] = intensity + floor(light_depth * 1000);
}

// **** Light Depth **** //
function light_set_depth(_depth)
{
	light_depth = clamp(_depth, 0, 1);
	z_depth = floor(z) + light_depth * 0.1;
	params[e_light.intensity_depth] = intensity + floor(light_depth * 1000);
}

function light_increment_depth(_increment)
{
	light_depth = clamp(light_depth + _increment, 0, 1);
	z_depth = floor(z) + light_depth * 0.1;
	params[e_light.intensity_depth] = intensity + floor(light_depth * 1000);
}

// **** Falloff (light index added in light rendering) **** //
function light_set_falloff(_falloff)
{
	falloff = clamp(_falloff, 0, 1);
	params[e_light.falloff] = falloff;
}

function light_increment_falloff(_increment)
{
	falloff = clamp(falloff + _increment, 0, 1);
	params[e_light.falloff] = falloff;
}

// **** Radius and angle packed together **** //
function light_set_radius(_radius)
{
	radius = max(0, ceil(_radius));
	params[e_light.radius_angle] = radius + degtorad(image_angle) * 0.1;	
}

function light_increment_radius(_increment)
{
	radius = max(0, ceil(radius + _increment));
	params[e_light.radius_angle] = radius + degtorad(image_angle) * 0.1;
}

function light_set_angle(_angle)
{
	image_angle = angle_normalize(_angle);
	params[e_light.radius_angle] = radius + degtorad(_angle) * 0.1;
}

function light_rotate_angle(_rot)
{
	image_angle = angle_normalize(image_angle + _rot);
	params[e_light.radius_angle] = radius + degtorad(image_angle) * 0.1;	
}

function light_update_light_directional()
{
	x = -dcos(image_angle) * shadow_length;
	y =  dsin(image_angle) * shadow_length;
}

function light_set_angle_directional(_angle)
{
	image_angle = angle_normalize(_angle);
	params[e_light.radius_angle] = radius + degtorad(_angle) * 0.1;
	update_light_direction();
}

function light_rotate_angle_directional(_rot)
{
	set_angle(image_angle + _rot);
}

function light_set_shadow_length_directional(_length)
{
	shadow_length = clamp(_length, 1, 16000);
	update_light_direction();
}

function light_increment_shadow_length_directional(_increment)
{
	shadow_length = clamp(shadow_length + _increment, 1, 16000);
	update_light_direction();
}

// **** Width and arc packed together **** //
function light_set_width(_width)
{
	width = max(0, ceil(_width));
	params[e_light.width_arc] = width + degtorad(arc) * 0.1; 
}

function light_increment_width(_increment)
{
	width = max(0, ceil(width + _increment));
	params[e_light.width_arc] = width + degtorad(arc) * 0.1; 
}

function light_set_arc(_arc)
{
	arc = clamp(_arc, 0, 181);
	params[e_light.width_arc] = width + degtorad(_arc) * 0.1;
}

function light_increment_arc(_increment)
{
	arc = clamp(arc + _increment, 0, 181);
	params[e_light.width_arc] = width + degtorad(arc) * 0.1;
}

// **** Shadow hardness **** //
function light_set_shadow_hardness(_hardness)
{
	_hardness = clamp(_hardness, 0.0, 1.0);
	shadow_hardness = _hardness;
	shadow_hardness_value = min(_hardness, 0.999999);
}

function light_increment_shadow_hardness(_increment)
{
	shadow_hardness = clamp(shadow_hardness + _increment, 0.0, 1.0);
	shadow_hardness_value = min(shadow_hardness, 0.999999);
}