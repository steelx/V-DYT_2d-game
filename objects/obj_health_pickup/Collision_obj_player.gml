/// @description obj_player collision obj_health_pickup

if other.hp > 0 and other.hp < other.max_hp {
    var _prev_hp = other.hp;
    other.previous_hp = _prev_hp;
    other.hp = min(_prev_hp+gain, other.max_hp);

    audio_play_sound(spr_chime1, 1, false);
    instance_create_depth(x, y, -depth, obj_health_picked_up);
    instance_destroy(id, false);
}
