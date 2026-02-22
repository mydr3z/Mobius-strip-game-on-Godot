extends PlayerState

class_name OuterSpaceState

var _horizontal_input:float;
var _vertical_input:float;

func _init(init_character:FirstPersonController, init_stateMachine:PlayerStateMachine):
	self.character = init_character
	self.stateMachine = init_stateMachine


func enter()->void:
	super();
	_horizontal_input = 0.0;
	_vertical_input = 0.0;


func exit()->void:
	super();


func handle_input()->void:
	super();
	var _input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	_horizontal_input = _input_vector.x;
	_vertical_input = _input_vector.y;


func move_update()->void:
	print("MoveUpdate")
	super.move_update();
	character.move_body(Vector3.ZERO);
	
	if !WorldPhysics.is_in_outer_space(character.get_position()):
		if WorldPhysics.get_depth(character.get_position()) < 0.0:
			stateMachine.change_state(character.get_state(FirstPersonController.State.WALKING));
		
		else: 
			stateMachine.change_state(character.get_state(FirstPersonController.State.INNER_FLYING));
	character.rotate_head();
