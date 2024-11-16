/// @description obj_sequence_spawner Create
// The sequence to play
sequence = noone;

// The instance that spawned this sequence
spawner = noone;

// The active sequence instance
active_sequence = noone;

// The layer for the sequence
sequence_layer = -1;

/// @description Create event

// Start the sequence
start_sequence = function() {
    if (sequence != noone) {
        sequence_layer = layer_create(depth - 1);
        active_sequence = layer_sequence_create(sequence_layer, x, y, sequence);
        
        // Set the scale based on the spawner's direction
        if (instance_exists(spawner)) {
            layer_sequence_xscale(active_sequence, spawner.image_xscale);
        }
    }
}

// Check if the sequence is finished and handle cleanup
check_spawner_sequence = function() {
    if (active_sequence != noone && layer_sequence_is_finished(active_sequence)) {
        cleanup_sequence();
        return true;
    }
    return false;
}

// Cleanup the sequence
cleanup_sequence = function() {
    if (active_sequence != noone) {
        layer_sequence_destroy(active_sequence);
        active_sequence = noone;
    }
    if (sequence_layer != -1) {
        layer_destroy(sequence_layer);
        sequence_layer = -1;
    }
    
    // Re-enable the spawner if it still exists
    if (instance_exists(spawner)) {
        with (spawner) {
            if variable_instance_exists(id, "enable_self") {
				enable_self(id);
			}
        }
    }
    
    // Destroy this object after cleanup
    instance_destroy();
}

