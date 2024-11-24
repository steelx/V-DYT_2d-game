/// @description obj_player collision obj_health_pickup

if other.hp > 0 and other.hp < other.max_hp {
    var _prev_hp = other.hp;
    other.previous_hp = _prev_hp;
    other.hp = min(_prev_hp+gain, other.max_hp);

    audio_play_sound(spr_chime1, 1, false);
    // Create a group of sparks with slightly different timing
	repeat(3) {
	    var _delay = random(10);  // Random delay up to 10 steps
	    with(instance_create_depth(other.x, other.y, depth-1, obj_spark)) {
		    // magical effect
		    var _hue = random_range(0, 255);
		    col_head = make_color_hsv(_hue, 200, 255);
		    col_tail = make_color_hsv(_hue, 155, 200);
    
		    // Randomize initial position slightly
		    spiral_angle = random(360);
		}
	}
	
	//destroy health item
	instance_destroy();
}
