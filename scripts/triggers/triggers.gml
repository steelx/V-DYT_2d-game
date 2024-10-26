function tooltip_interaction_func1() {
    show_debug_message($"Tooltip interaction triggered! x {x} y {y}");
}

function show_dialog_1() {
    instance_create_layer(x, y, "Instances", obj_dialog_1);
}
