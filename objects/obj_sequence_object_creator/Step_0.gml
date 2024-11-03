/// @description obj_sequence_object_creator Step

if (sequence_element_id != noone) {
    var seq_instance = layer_sequence_get_instance(sequence_element_id);
    if (seq_instance != noone) {
        if (!seq_instance.paused && !seq_instance.finished) {
            if (object_to_create != noone) {
                instance_create_layer(x_pos, y_pos, layer, object_to_create);
                instance_destroy();
            }
        }
    }
}
