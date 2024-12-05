/* 
	Solution for game intialization.  The object __game_init creates a stack of these structs
	and then processes the top each step until the stack is empty. Allows for any given part to 
	use multiple steps for any costly loading as they will be processed until returning true.
	
	All loaders should inherit from __loader_base struct and override the process() function.
*/

function __loader_base() constructor
{
	static process = function() { return true; }
}

function loader_system() : __loader_base() constructor
{
	static process = function()
	{
		// Examples for system loading...
		// ** Create gamestate object
		// ** Load system data
		// ** Load persistent camera
		
		instance_create_depth(0, 0, 0, le_camera, { follow_object : le_navigate	});
		return true;
	}
}

function loader_assets() : __loader_base() constructor
{
	static process = function()
	{
		// Examples for asset loading...
		// ** Load audio groups
		// ** Load graphical data such as fetching common texture groups
		
		return true;
	}
}

function loader_game_data() : __loader_base() constructor
{
	static process = function()
	{
		// Examples for loading game data...
		// ** Load player data
		// ** Load game type objects
		
		return true;
	}
}

function loader_precise_sprite_outlines(_sprites_per_step) : __loader_base() constructor
{
	// Loader for precise sprite outlines
	// As creating the outlines can be costly this breaks things up over multiple steps
	
	var _arr   = tag_get_asset_ids("add_outline", asset_sprite),
		_len   = array_length(_arr),
		_stack = ds_stack_create();
	
	for (var _i = 0; _i < _len; _i++)
		ds_stack_push(_stack, _arr[_i]);
		
	sprite_stack = _stack;
	per_step     = _sprites_per_step;
	
	static process = function()
	{
		if (!ds_exists(sprite_stack, ds_type_stack))
			return true;
		
		for (var _i = 0; _i < per_step; _i++)
		{
			if (ds_stack_empty(sprite_stack))
			{
				ds_stack_destroy(sprite_stack);
				return true;
			}
			
			var _sprite = ds_stack_pop(sprite_stack);

			if (sprite_exists(_sprite))
				get_sprite_outline(_sprite);
		}
		
		return false;
	}
}