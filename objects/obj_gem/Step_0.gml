/// @description obj_gem Step event

with(light_id) {
    x = other.x;
    y = other.y;
}

// Check if out of room
if (y > room_height) {
    instance_destroy();
}

// generate spark
if die {
	repeat(spark_count) {
		var _inst = instance_create_depth(x, y, depth, obj_spark);
		// set color
		var _col_head = 0; var _col_tail = 0;
		switch(image_index) {
			case 0:
			_col_head = c_lime; _col_tail = make_color_rgb(137, 190, 133);
			break;
			case 1:
			_col_head = c_yellow; _col_tail = make_color_rgb(218, 215, 152);
			break;
			case 2:
			_col_head = c_aqua; _col_tail = make_color_rgb(152, 193, 218);
			break;
			case 3:
			_col_head = c_fuchsia; _col_tail = make_color_rgb(200, 152, 218);
			break;
			case 4:
			_col_head = c_red; _col_tail = make_color_rgb(220, 152, 154);
			break;
		}
		
		_inst.col_head = _col_head;
		_inst.col_tail = _col_tail;
	}
	
	instance_destroy();
}

