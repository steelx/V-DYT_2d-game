/// @description Shadow grid and Layers

init_shadow_grid();

var _back     = set_layer_scripts(layers_background, layer_background_begin, layer_background_end),
	_normal   = set_layer_scripts(layers_normal, layer_normal_begin, layer_normal_end),
	_material = set_layer_scripts(layers_material, layer_material_begin, layer_material_end);

// If no background is found create one
// Required for clearing the normal and material surfaces
if (_back == LE_LAYERS_INVALID)	
{
	slog("Background layer not found, creating one...");
	layer_create(15999, "light_surfaces_clear");
	set_layer_scripts(["light_surfaces_clear"], layer_background_begin, layer_background_end);
}

slog("Lighting BACK layer scripts set : Normals..." + 
	(_normal != LE_LAYERS_INVALID ? "ok" : "not found") + " : Materials..." + 
	(_material != LE_LAYERS_INVALID? "ok" : "Not found"));


if (_normal != LE_LAYERS_INVALID)
{
	layer_params_normal_set(_normal, layers_normal_emissive);	
}

if (_material != LE_LAYERS_INVALID)
{
	layer_params_material_set(_material, layers_material_occlude, 0);
}

// Add front layer scripts
var _normal_front   = set_layer_scripts(layers_normal_front, layer_normal_begin, layer_normal_end),
	_material_front = set_layer_scripts(layers_material_front, layer_material_begin, layer_material_end),
	_pre_composite  = layer_create(max(depth, max(_normal_front, _material_front)) + 1, "light_pre_composite");

// Pre-composite goes right before the highest depth of the front layers
instance_create_layer(0, 0, _pre_composite, __light_pre_composite);

slog("Lighting FRONT layer scripts set : Normals..." + 
	(_normal_front != LE_LAYERS_INVALID ? "ok" : "not found") + " : Materials..." + 
	(_material_front != LE_LAYERS_INVALID? "ok" : "Not found"));

if (_normal != LE_LAYERS_INVALID)
{
	layer_params_normal_set(_normal_front, layers_normal_front_emissive);	
}

if (_material_front != LE_LAYERS_INVALID)
{
	layer_params_material_set(_material_front, layers_material_front_occlude, 1);
}

loaded = true;