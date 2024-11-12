/* 
	The classic Behavior Tree to GMS 2.3+
	if you don't know what you're doing here or need to learn what is a Behavior Tree, 
	you can see it on our references

	https://github.com/VitorEstevam/GML-Behaviour-Tree
	Mantained by @vitorstvm and @jalesjefferson
*/

enum BTStates {
    Running,   // Task/sequence is still executing (in progress)
    Success,   // Task/sequence completed successfully
    Failure,   // Task/sequence failed to complete
    Off       // Task/sequence is inactive
}

///@abstract
function BTreeNode() constructor{
    name = "BT_TREE_NODE_BASE";     
    status = BTStates.Running;      
    visited = false;                
		
    children = [];                  
    children_arr_len = 0;           
    black_board_ref = noone;        
    
    static Init = function(){}
    
    static Process = function(){    
        return BTStates.Success;
    }
    
    static ChildAdd = function(_child){
        array_push(children, _child);
        ++children_arr_len;
    }
	
	static FindNodeByName = function(_name) {
        // Check if this node matches the name
        if (name == _name) return self;
        
        // Check children recursively
        var _i = 0;
        repeat(children_arr_len) {
            var _found = children[_i].FindNodeByName(_name);
            if (_found != noone) return _found;
            ++_i;
        }
        
        return noone;
    }
	
	static NodeProcess = function(_node){
		
		if(_node.visited == false){ // Initial configure
			_node.black_board_ref = black_board_ref; 
			_node.visited = true;
			_node.Init();
		}
		
		var _status = _node.Process(); // Returning State
		
		if(_status == BTStates.Running and black_board_ref.running_node == noone){
			black_board_ref.running_node = _node
		}
		else if( _status != BTStates.Running and black_board_ref.running_node != noone){
			black_board_ref.running_node = noone;
		}
		
		return _status
	}
	
	static DrawGUI = function(_world_x, _world_y) {
        // Convert world coordinates to GUI coordinates
		var _world_xy = world_to_gui(_world_x, _world_y)
        var _gui_x = room_x_to_gui(_world_x);
		var _gui_y = room_y_to_gui(_world_y);
        
        var _color = c_white;
        switch(status) {
            case BTStates.Running: _color = c_yellow; break;
            case BTStates.Success: _color = c_lime; break;
            case BTStates.Failure: _color = c_red; break;
            case BTStates.Off: _color = c_gray; break;
        }
        
        draw_set_color(_color);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        
        // Draw status above object
        draw_text(_gui_x, _gui_y - 10, name);
        if(black_board_ref != noone && black_board_ref.running_node != noone) {
            draw_text(_gui_x, _gui_y - 25, "Running: " + black_board_ref.running_node.name);
        }
        
        // Reset draw properties
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

}

///@abstract
function BTreeComposite() : BTreeNode() constructor{}

///@abstract
function BTreeLeaf() : BTreeNode() constructor{}

///@abstract
function BTreeDecorator() : BTreeNode() constructor{
	/// @overwrite
	static ChildAdd = function(child_node){
		children[0] = child_node;
		children_arr_len = 1;
  }
}

/// @param inst_id - Expects an instance id.
function BTreeRoot(inst_id): BTreeNode() constructor{
	name = "BT_ROOT";
	status = BTStates.Off;
	array_push(children, noone);    
	
	black_board = {  
			user : inst_id,           
	    root_reference : other,     
	    running_node: noone,        
	};
    
	black_board_ref = black_board; 
    
	/// @override 
	static Init = function(){
		status = BTStates.Running;
	}
	
	/// @override 
	static Process = function(){
		if(black_board.running_node != noone)
			NodeProcess(black_board.running_node);
		
		else if(children[0] != noone){
			if(status == BTStates.Running)
			    NodeProcess(children[0]);
	    }
	}

	/// @override 
	/// @param child_node - Expects a BTreeNode.
	static ChildAdd = function(child_node){
		children[0] = child_node;
		children_arr_len = 1;
	}
	
	/// @override
    static DrawGUI = function(x = 10, y = 10) {
        // Draw root status
        var _color = c_white;
        switch(status) {
            case BTStates.Running: _color = c_yellow; break;
            case BTStates.Success: _color = c_lime; break;
            case BTStates.Failure: _color = c_red; break;
            case BTStates.Off: _color = c_gray; break;
        }
        
        draw_set_color(_color);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(x, y, "BT Status: " + name);
        
        // Draw running node if exists
        if(black_board.running_node != noone) {
            draw_text(x, y + 20, "Active Node: " + black_board.running_node.name);
            
            // If running node has sequence/selector name, show it
            var _running_node = black_board.running_node;
            if(variable_struct_exists(_running_node, "sequence_name")) {
                draw_text(x, y + 40, "Sequence: " + _running_node.sequence_name);
            }
            else if(variable_struct_exists(_running_node, "selector_name")) {
                draw_text(x, y + 40, "Selector: " + _running_node.selector_name);
            }
        }
        
        draw_set_color(c_white);
    }
}

function BTreeSequence(_sequence_name = "") : BTreeComposite() constructor{
	name = "BT_SEQUENCE";
	sequence_name = _sequence_name;
        
    /// @override 
    static Process = function(){
        var _i = 0; 
        repeat(children_arr_len){
            if(children[_i].status == BTStates.Running){
                switch( NodeProcess(children[_i])){
                    case BTStates.Running: return BTStates.Running;
                    case BTStates.Failure: return BTStates.Failure; 
                }
            }
            
            ++_i;
        }
        
        return BTStates.Success;
    }
}

function BTreeSelector(_selector_name = "") : BTreeComposite() constructor{
	name = "BT_SELECTOR";
	selector_name = _selector_name
    
		/// @override
    static Process = function(){
        var _i = 0;
        repeat(children_arr_len){
            if(children[_i].status == BTStates.Running){
                switch(NodeProcess(children[_i])){
                    case BTStates.Running: return BTStates.Running;
                    case BTStates.Success: return BTStates.Success;
                }
            }

            ++_i;
        }
        
        return BTStates.Failure;
    }     
}

function BTreeInverter() : BTreeDecorator() constructor{
	name = "BT_Inverter";
	
	/// @override
	static Process = function(){
		var _state = NodeProcess(children[0]);
		switch(_state){
			case BTStates.Failure: return BTStates.Success;
			case BTStates.Success: return BTStates.Failure;
			default: return _state;
		}
	}
}

function BTreeSucceeder() : BTreeDecorator() constructor{
	name = "BT_Succeeder";
	
	/// @override
	static Process = function(){
		var _state = NodeProcess(children[0]);
		return BTStates.Success;
	}
}
