/// @description obj_archer create

// Inherit the parent event
event_inherited();

max_hp = 2;
hp = max_hp;

defeated_object = obj_archer_defeated;
move_speed = 2;
state = CHARACTER_STATE.IDLE;

move_chance = 0.5;
roam_counter_init = 120;
roam_counter = roam_counter_init;
roam_timer = get_room_speed();
alarm_set(1, roam_timer);

attack_range = 164;
