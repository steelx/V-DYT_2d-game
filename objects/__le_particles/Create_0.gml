shd_particle_albedo = shd_particle_albedo_glsl_es;

particle_system = part_system_create();
			part_system_automatic_draw(particle_system, false);
			part_system_automatic_update(particle_system, false);

part_types = ds_list_create();

#region SYSTEM_FUNCTIONS
	
	draw = function() { part_system_drawit(particle_system); }
	
	clear = function() { part_system_clear(particle_system); }
	
	part_type_add = function()
	{
		var _type = part_type_create();
		ds_list_add(part_types, _type);
		return _type;
	}

	set_depth = function(_depth) 
	{ 
		part_system_depth(particle_system, _depth); 
		depth = _depth;
	}

	set_layer = function(_layer)
	{
		var _layer_id = layer_get_id(_layer);
		if (_layer_id == -1) return;
		layer_add_instance(_layer_id, id);
		part_system_layer(particle_system, _layer);	
	}
		
	clean_up = function()
	{
		for (var _i = 0, _size = ds_list_size(part_types); _i < _size; _i++)
			part_type_destroy(part_types[|_i]);

		part_system_destroy(particle_system);
	}
	
#endregion

// Creates the actual particle types and functions
event_user(0);