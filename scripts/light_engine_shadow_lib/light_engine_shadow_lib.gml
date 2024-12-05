function shadow_update_depth()
{
	normal = color_make_normal_depth(has_normal_map, emissive_strength, depth);
	material = color_make_material_depth(metallic, roughness, depth); 
}

function shadow_set_emissive(_value)
{
	emissive_strength = clamp(_value, 0, 1);
	var _depth = depth + 16000;
	normal = make_color_rgb(emissive_strength * 255, ((_depth & 32512) >> 8) + 128 * has_normal_map, _depth & 255);
}

function shadow_set_metallic(_metal)
{
	metallic = clamp(_metal, 0, 1);
	material = color_make_material_depth(metallic, roughness, depth); 
}

function shadow_set_roughness(_rough)
{
	roughness = clamp(_rough, 0, 1);
	material = color_make_material_depth(metallic, roughness, depth); 
}

function shadow_set_metal_rough(_metal, _rough)
{
	metallic = clamp(_metal, 0, 1);
	roughness = clamp(_rough, 0, 1);
	material = color_make_material_depth(metallic, roughness, depth); 
}

function shadow_set_shadow_depth(_depth)
{
	shadow_depth = clamp(_depth, 0, 1);
	shadow_mag_depth = shadow_magnitude * 10 + shadow_depth;
}

function shadow_increment_shadow_depth(_increment)
{
	shadow_depth = clamp(shadow_depth + _increment, 0, 1);
	shadow_mag_depth = shadow_magnitude * 10 + shadow_depth;
}

function shadow_set_shadow_magnitude(_magnitude)
{
	shadow_magnitude = floor(clamp(_magnitude, 1, 32));
	shadow_mag_depth = shadow_magnitude * 10 + shadow_depth;
}

function shadow_increment_shadow_magnitude(_increment)
{
	shadow_magnitude = floor(clamp(shadow_magnitude + _magnitude, 1, 32));
	shadow_mag_depth = shadow_magnitude * 10 + shadow_depth;
}