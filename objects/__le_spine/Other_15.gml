/// @description Animation mixes

// Set default mixes
var _anims = ds_list_create();
skeleton_animation_list(sprite_index, _anims);
var _size = ds_list_size(_anims),
	_mix = default_mix;
	
for(var _i = 0; _i < _size; _i++)
	for(var _j = _i + 1; _j < _size; _j++)
		skeleton_animation_mix(_anims[| _i], _anims[| _j], _mix);

ds_list_destroy(_anims);	


// Set specific mixes. E.g., skeleton_animation_mix("idle", "run", 0.1);

/**** Spine Example Hero ****

	- Animation names - 
	attack
	crouch
	crouch-from fall
	fall
	head-turn
	idle
	idle-from fall
	jump
	morningstar pose
	run
	run-from fall
	walk
	
	- Skins -
	default
	weapon/morningstar
	weapon/sword
	
*/