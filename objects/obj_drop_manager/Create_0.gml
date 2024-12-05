/// @description obj_drop_manager Create_Event
drops = [];

add_drop_item = function(_drop_item) {
    array_push(drops, _drop_item);
};

remove_drop_item = function(_inst_id) {
    var _index = array_find_index(drops, method({ inst_id: _inst_id }, function(_element) {
        return _element.inst_id == self.inst_id;
    }));
    
    if (_index != -1) {
        array_delete(drops, _index, 1);
    }
};

cleanup = function() {
    // Clear drops array when room ends
    array_foreach(drops, function(_drop) {
        _drop.arc_path.Clean();
    });
    drops = [];
};
