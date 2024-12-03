/// @description obj_gem Destroy: clear lights
with obj_drop_manager remove_drop_item(other.id);
instance_destroy(light_id);