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
    
    // Check if the current item is a sequence or a function
    if (is_method(_current_item)) {
        // If it's a method/function, execute it
        _current_item();
        
        // Move to the next item in the array
        global.current_sequence_index++;
        
        // Recursively call to handle the next item
        load_next_sequence(_sequence_array);
    } else {
		global.sequence_layer = layer_create(depth);
        // Create the sequence and store its ID
		global.current_sequence = layer_sequence_create(global.sequence_layer, x, y, _current_item);
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
    if (global.current_sequence != noone) {
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

// Example usage
function start_sequence_chain_1() {
    global.sequence_array = [
		function(){ global.game_state = GAME_STATES.CUTSCENE; },
        seq_1,           // First sequence
        seq_2,           // Second sequence
        function() {     // Function to transition to room
			global.game_state = GAME_STATES.PLAYING;
            room_goto_next();
        }
    ];
    
    global.current_sequence_index = 0;
    load_next_sequence(global.sequence_array);
}