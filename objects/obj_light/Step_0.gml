/// @description Insert description here
event_inherited();

// we will change colour. hence below will run only onces
if colour == c_black {
	switch(light_type) {
		case "wall":
			intensity = 0.4;
			radius = 34;
			colour = make_color_rgb(220, 134, 39);
		break;
		case "window":
			intensity = 0.2;
			radius = 27;
			colour = make_color_rgb(220, 134, 39);
			flickering = false;
		break;
		case "chest":
			intensity = 0.1;
			radius = 20;
			colour = c_red;
			flickering = false;
		break;
		case "water":
			intensity = 0.3;
			radius = 20;
			colour = c_aqua;
		break;
		case "gem":
			intensity = 0.001;
			radius = 15;
			switch(col_index) {
				case 0: colour = c_lime; break;
				case 1: colour = c_yellow; break;
				case 2: colour = c_aqua; break;
				case 3: colour = c_fuchsia; break;
				case 4: colour = c_red; break;
			}
		break;
	}
}
