function create_pixelated_blood_fx(_blood_splash_count = 20, _blood_splash_spread = 16, _pixel_size = 8) {
	// Create the pixelated blood splash effect
	for (var i = 0; i < _blood_splash_count; i++) {
	    var _x = other.x + random_range(-_blood_splash_spread, _blood_splash_spread);
	    var _y = other.y + random_range(-_blood_splash_spread, _blood_splash_spread);
	    instance_create_layer(_x, _y, "Enemies", obj_blood_splash_pixelate);
	}
}

function create_blood_splash(_blood_splash_count = 20, _blood_splash_spread = 16, _pixel_size = 8) {
	// Create the pixelated blood splash effect
	for (var i = 0; i < _blood_splash_count; i++) {
	    var _x = other.x + random_range(-_blood_splash_spread, _blood_splash_spread);
	    var _y = other.y + random_range(-_blood_splash_spread, _blood_splash_spread);
	    instance_create_layer(_x, _y, "Enemies", obj_blood_splash);
	}
}

