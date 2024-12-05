/// @description obj_drop_manager Step_Event
// Only process drops that still exist
for (var i = 0; i < array_length(drops); i++) {
    var _drop = drops[i];
    with(_drop.inst_id) {
        if (drop_item.current_point != undefined) {
            drop_item.UpdateArcMovement();
        } else if (!drop_item.can_pickup) {
            drop_item.UpdateFalling();
        }
    }
}
