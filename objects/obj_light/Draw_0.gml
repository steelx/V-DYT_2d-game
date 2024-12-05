/// @description Insert description here
event_inherited();

// flickering gets randomized each draw
var _radius = flickering ? random_range(2, 4) : 0;
var _intensity = flickering ? random(0.12) : 0;

gpu_set_blendmode(bm_add);

if is_circle {
	draw_circle_color(x, y, radius+_radius, merge_color(c_black, colour, intensity+_intensity), c_black, 0);
} else {
	//ellipse
	var _w = (abs(sprite_width) * 0.75)+_radius;
	var _h = abs(sprite_height) + abs(sprite_height)*0.75;
	draw_ellipse_color(x-_w, y-_h, x+_w, y+_h, merge_color(c_black, colour, intensity+_intensity), c_black, 0);
}

gpu_set_blendmode(bm_normal);