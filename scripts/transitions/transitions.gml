global.mid_transition = false;
global.room_target = -1;

function transition_place_sequence(_sequence){
	if (layer_exists("transitions")) layer_destroy("transitions");
	
	var _layer = layer_create(-9999, "transitions");
	layer_sequence_create(_layer, 0, 0, _sequence);
}


/*
* @function transition_init(rm_level_1, seq_fade_out, seq_fade_in);
* starts a sequence transition
*/
function transition_init(_room_target, _seq_start, _seq_end) {
	if (global.mid_transition == true) return false;
	
	global.mid_transition = true;
	global.room_target = _room_target;
	transition_place_sequence(_seq_start);
	layer_set_target_room(_room_target);
	transition_place_sequence(_seq_end);
	layer_reset_target_room();
	return true;
}

/// End of frame moment for seq_fade_out
function transition_change_room() {
	room_goto(global.room_target);
}

/// End of frame moment for seq_fade_in
function transition_finished() {
	var _transitions_layer = layer_get_id("transitions");
    
    if (_transitions_layer != -1) {
        var _sequences = layer_get_all_elements(_transitions_layer);
        
        for (var _i = 0; _i < array_length(_sequences); _i++) {
            if (layer_get_element_type(_sequences[_i]) == layerelementtype_sequence) {
                layer_sequence_destroy(_sequences[_i]);
            }
        }
        
        //layer_destroy(_transitions_layer);
    }
    
    global.mid_transition = false;
}