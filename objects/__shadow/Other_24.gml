/// @description Draw material map

if (has_occlusion)
{
	draw_sprite_ext(material_map, image_index, x, y, image_xscale, image_yscale, image_angle, material, shadow_depth);
}
else
{
	shader_set_occlusion(false);
	draw_sprite_ext(material_map, image_index, x, y, image_xscale, image_yscale, image_angle, material, shadow_depth);
	shader_set_occlusion(global.le_object_occlusion);
}