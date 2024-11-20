/// @desc: example object structure:
/*
// ojb_load_room_1 Create Event
create_sequence_controller();
start_sequence_chain_1();

// Step Event
check_sequence_completion();
*/

/// @function load_next_sequence(sequence_array)
/// @description Loads the next sequence in the array or executes a function if encountered
/// @param {Array} _sequence_array Array of sequences or functions to cycle through
function load_next_sequence(_sequence_array) {
    // Check if we've gone through all items in the array
    if (global.current_sequence_index >= array_length(_sequence_array)) {
        global.current_sequence_index = 0; // Reset to start if we've reached the end
        return;
    }
    
    // Get the current item in the sequence array
    var _current_item = _sequence_array[global.current_sequence_index];
    
    // Check if the current item is a sequence, a function, or a sequence-creating function
    if (is_method(_current_item)) {
        // If it's a method/function, execute it
        var _result = _current_item();
        
        // If the function returns a sequence, create it
        if (sequence_exists(_result)) {
            global.sequence_layer = layer_create(depth);
            global.current_sequence = layer_sequence_create(global.sequence_layer, x, y, _result);
        } else {
            // If it doesn't return a sequence, move to the next item
            global.current_sequence_index++;
            load_next_sequence(_sequence_array);
        }
    } else if (sequence_exists(_current_item)) {
        // If it's a pre-existing sequence
        global.sequence_layer = layer_create(depth);
        global.current_sequence = layer_sequence_create(global.sequence_layer, x, y, _current_item);
    } else {
        // If it's neither a function nor a sequence, skip it
        global.current_sequence_index++;
        load_next_sequence(_sequence_array);
    }
}


// Create Event of a controller object
function create_sequence_controller() {
    global.current_sequence_index = 0;
	global.sequence_array = [];
    global.current_sequence = noone;
    global.sequence_layer = -1;
}

// Step Event of the controller object - check for sequence completion
function check_sequence_completion() {
    if (global.current_sequence != noone and is_array(global.sequence_array)) {
        // Check if sequence has finished
		if (layer_sequence_is_finished(global.current_sequence)) {
			layer_sequence_destroy(global.current_sequence);
			layer_destroy(global.sequence_layer);
				
			global.current_sequence = noone;
            global.current_sequence_index++;
                
            // Load the next item in the sequence array
            load_next_sequence(global.sequence_array);
	    }
            
    }
}

function stop_wind_sound() {
	audio_stop_sound(snd_amb_wind);
}
