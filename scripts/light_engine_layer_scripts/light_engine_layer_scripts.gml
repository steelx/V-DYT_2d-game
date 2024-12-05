function get_begin_end_layers(_layers)
{
	var	_begin = -1,
		_depth = 0,
		_begin_depth = -infinity,
		_end   = -1,
		_end_depth = infinity;
		
	for (var _l = 0, _id, _size = array_length(_layers); _l < _size; _l++)
	{
		_id = layer_get_id(_layers[_l]);
		if (_id == -1) continue;
		
		layer_set_visible(_id, true);
		
		_depth = layer_get_depth(_id);
		if (_depth > _begin_depth)
		{
			_begin_depth = _depth;
			_begin = _id;
		}
		// Don't branch it could be begin and end
		if (_depth < _end_depth)
		{
			_end_depth = _depth;
			_end = _id;
		}
	}

	return [_begin, _end];
}

function set_layer_scripts(_layers_array, _scr_begin, _scr_end)
{
	#macro LE_LAYERS_INVALID -32000
	
	var _layers = get_begin_end_layers(_layers_array),
		_begin  = _layers[0],
		_end    = _layers[1];
		
	if (_begin != -1 && _end != -1)
	{
		if (layer_get_script_begin(_begin) != _scr_begin) layer_script_begin(_begin, _scr_begin);
		if (layer_get_script_end(_end)     != _scr_end)   layer_script_end(_end, _scr_end);
		return _begin;
	}	
	
	return LE_LAYERS_INVALID;
}

function set_layer_scripts_material(_layer, _has_occlusion, _shadow_depth)
{
	layer_script_begin(_layer, layer_material_begin);
	layer_script_end(_layer, layer_material_end);
	layer_params_material_set(_layer, _has_occlusion, _shadow_depth);
}

function set_layer_scripts_normal(_layer, _emissive = LAYER_NO_EMISSIVE)
{
	layer_script_begin(_layer, layer_normal_begin);
	layer_script_end(_layer, layer_normal_end);
	layer_params_normal_set(_layer, _emissive);
}

function layer_background_begin()
{ 
	if (event_type != ev_draw || event_number != 0) return;
	gpu_set_colorwriteenable(1, 1, 1, 0); 
	draw_clear_alpha(c_black, 0);
}
		
function layer_background_end()
{ 
	if (event_type != ev_draw || event_number != 0) return;
	gpu_set_colorwriteenable(1, 1, 1, 1); 
		
	with (light_engine)
	{
		if (surface_width == -1) return;
	
		if (!surface_exists(surface_normal)) surface_normal = surface_create(surface_width , surface_height);
		surface_set_target(surface_normal);
		draw_clear_alpha(c_white, 0);
		surface_reset_target();
		
		if (!surface_exists(surface_material)) surface_material = surface_create(surface_width , surface_height);
		surface_set_target(surface_material);
		draw_clear_alpha(c_white, 0);
		surface_reset_target();
		
		if (!surface_exists(surface_depth)) surface_depth = surface_create(surface_width, surface_height);
		surface_set_target(surface_depth);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
}

function layer_normal_begin() 
{	
	static _u_params = shader_get_uniform(shd_draw_normals_layer_glsl_es, "u_params");
	
	if (event_type != ev_draw || event_number != 0) return;
	
	with (light_engine)
	{
		if (!surface_exists(surface_normal)) return;
		
		var _params = layer_params_normal_get_depth(gpu_get_depth());
				
		surface_set_target(surface_normal);
		shader_set(shd_draw_normals_layer_glsl_es);
		shader_set_uniform_f(_u_params,	_params[e_layer_normal.emissive]);
		gpu_set_blendenable(false);
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
		gpu_set_zfunc(cmpfunc_lessequal);
		camera_apply(view_get_camera(view_current));
		layer_is_set = true;
	}
}

function layer_normal_end()   
{ 
	if (event_type != ev_draw || event_number != 0) return;
	
	with (light_engine)
	{	
		if (layer_is_set)
		{
			surface_reset_target();
			shader_reset();
			gpu_set_blendenable(true);
			gpu_set_ztestenable(false);
			gpu_set_zwriteenable(false);
			layer_is_set = false;
		}
	}
}

function layer_material_begin() 
{	
	static _u_params = shader_get_uniform(shd_draw_materials_layer_glsl_es, "u_params");
	static _u_params_nomrt = shader_get_uniform(shd_draw_materials_layer_nomrt_glsl_es, "u_params");
	
	if (event_type != ev_draw || event_number != 0) return;
	
	with (light_engine)
	{
		if (!surface_exists(surface_material) || !surface_exists(surface_depth)) return;

		var _params = layer_params_material_get_depth(gpu_get_depth());

		if (shadow_type == LE_SHADOW_TYPE_HARD)
		{
			surface_set_target(surface_material);
			shader_set(shd_draw_materials_layer_nomrt_glsl_es);
			shader_set_uniform_f(_u_params_nomrt, _params[e_layer_material.occlusion], _params[e_layer_material.shadow_depth]);
		}
		else
		{
			surface_set_target_ext(0, surface_material);
			surface_set_target_ext(1, surface_depth);	
			shader_set(shd_draw_materials_layer_glsl_es);
			shader_set_uniform_f(_u_params, _params[e_layer_material.occlusion], _params[e_layer_material.shadow_depth]);
		}
		
		gpu_set_blendenable(false);
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
		gpu_set_zfunc(cmpfunc_lessequal);
		camera_apply(view_get_camera(view_current));
		layer_is_set = true;
	}
}

function layer_material_end()   
{ 
	if (event_type != ev_draw || event_number != 0) return;
	
	with (light_engine)
	{	
		if (layer_is_set)
		{
			surface_reset_target();
			shader_reset();
			gpu_set_blendenable(true);
			gpu_set_ztestenable(false);
			gpu_set_zwriteenable(false);
			layer_is_set = false;
		}
	}
}

enum e_layer_material
{
	occlusion,
	shadow_depth
}

function layer_params_get_material()
{
	static _params = ds_map_create();
	return _params;
}

function layer_params_clear_material()
{
	ds_map_clear(layer_params_get_material());
}

function layer_params_material_set(_layer, _occlusion, _shadow_depth)
{
	static _params = layer_params_get_material();
		
	// We use the layer depth as the key so it can be retrieved with gpu_get_depth()
	ds_map_add(_params, layer_get_depth(_layer), [_occlusion, _shadow_depth]);
}

function layer_params_material_get(_layer)
{
	static _params = layer_params_get_material();
	return _params[? layer_get_depth(_layer)];	
}

function layer_params_material_get_depth(_depth)
{
	static _params = layer_params_get_material();
	return _params[? _depth];	
}

enum e_layer_normal
{
	emissive
}

#macro LAYER_NO_EMISSIVE -100

function layer_params_get_normal()
{
	static _params = ds_map_create();
	return _params;
}

function layer_params_clear_normal()
{
	ds_map_clear(layer_params_get_normal());
}

function layer_params_normal_set(_layer, _emissive = LAYER_NO_EMISSIVE)
{
	static _params = layer_params_get_normal();
	ds_map_add(_params, layer_get_depth(_layer), [max(0, _emissive)]);
}

function layer_params_normal_get(_layer)
{
	static _params = layer_params_get_normal();
	return _params[? layer_get_depth(_layer)];	
}

function layer_params_normal_get_depth(_depth)
{
	static _params = layer_params_get_normal();
	return _params[? _depth];	
}