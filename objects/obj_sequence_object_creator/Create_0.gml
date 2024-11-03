/// @desc: obj_sequence_object_creator Create
/// To avoid initializing the object's create event immediately when adding it to the sequence,
/// we use a deferred creation approach.
/// This involves creating a placeholder object that will instantiate the actual object
/// when the sequence reaches that point.
object_to_create = noone;
sequence_element_id  = noone;
x_pos = 0;
y_pos = 0;
