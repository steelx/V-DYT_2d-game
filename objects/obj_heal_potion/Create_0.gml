/// @description obh_heal_potion Create: gems drops from enemy death
randomize();
drop_item = new DropItem(id, x, y, "gem");
with obj_drop_manager add_drop_item(other.drop_item);

// has bounce happned
die = false;
spark_count = 3;
can_pickup = false;

// Optional: Add debug drawing
debug_draw = false;

// light

light_id = instance_create_layer(x, y, "Lights", obj_gem_light);
/*
with(light_id) {
    radius = 1;
    intensity = 0.001;
    light_type = "gem";
    col_index = other.image_index;
}

*/