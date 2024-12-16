/// @description obj_pickup_sword
event_inherited();

tooltip_text = "[spr_key_e] Pick up sword";
interaction_area = 32;
tooltip_instance = noone;
interaction_function = function() {
	if instance_exists(obj_player) {
		with(obj_inventory) has_sword = true;
	}
	instance_destroy(tooltip_instance);
	instance_destroy(id);
};

can_pickup = false;
vel_x = 0;
vel_y = 0;
state = CHARACTER_STATE.MOVE;
