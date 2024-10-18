/// @description obj_slime_enemy create

// Inherit the parent event
event_inherited();

max_hp = 2;
hp = max_hp;

defeated_object = obj_slime_defeated;
move_speed = 2;
state = CHARACTER_STATE.IDLE;
jump_speed = 12;
jump_chance = 0.5;
roam_timer = get_room_speed();
alarm_set(SLIME_ROAM, roam_timer);

attack_range = 64;
