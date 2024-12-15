/// @description obj_interact_parent
// You can write your code in this editor
tooltip_text = "[spr_key_e] Enter";
idle_sprite = spr_radio;
near_sprite = spr_radio_on;
interaction_function = undefined;

interaction_area = 32;
tooltip_instance = noone;
sprite_index = idle_sprite;
image_speed = 1;

init = function(_idle_sprite, _near_sprite, _interaction_function = undefined, _image_speed = 1) {
	idle_sprite = _idle_sprite;
	near_sprite = _near_sprite;
	interaction_function = _interaction_function;
	
	sprite_index = idle_sprite;
	image_speed = _image_speed;
};
