/// @description Set normal and emissive

update_depth    = method(id, shadow_update_depth);
set_emissive    = method(id, shadow_set_emissive);
set_metallic    = method(id, shadow_set_metallic);
set_roughness   = method(id, shadow_set_roughness);
set_metal_rough = method(id, shadow_set_metal_rough);

has_normal_map = (normal_map != sprite_index);
update_depth();