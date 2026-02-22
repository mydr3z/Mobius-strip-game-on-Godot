class_name WalkingState

extends PlayerState

var JUMP_ACCEL_COEF:float = 280.0;
var JUMP_DEPTH:float = 0.2;

var _is_jumping:bool = false;
var _is_running:bool = false;

var _WALK_ACCEL_COEF:float = 18.0;   
var _RUN_COEF:float = 2.0; 
var _GRAVITY_SMOOTH:float = 0.92;
var _horizontal_input:float;
var _vertical_input:float;


func _init(init_character:FirstPersonController, init_stateMachine:PlayerStateMachine):
	self.character = init_character
	self.stateMachine = init_stateMachine


func enter()->void:
	super();


func exit()->void:
	super();
	_is_jumping = false;


func handle_input()->void:
	super.handle_input();
	
	var input_vector = Input.get_vector("move_left", "move_right", "move_back", "move_forward");
	
	_horizontal_input = input_vector.x;
	_vertical_input = input_vector.y;
	
	if Input.is_action_just_pressed("jump"):
		_is_jumping = true;
	
	_is_running = Input.is_action_pressed("run");


func move_update()->void:
	super.move_update();
	
	var forward:Vector3 = WorldPhysics.get_local_gravity(character.get_pos()).cross(character.global_transform.basis.x.normalized());
	var side:Vector3 = forward.cross(WorldPhysics.get_local_gravity(character.get_pos()));
	
	var _acceleration_forw = _vertical_input * forward;
	var _acceleration_side = _horizontal_input * side;
	var _acceleration = _acceleration_forw + _acceleration_side;
	
	if _acceleration.length_squared() > 1.0:
		_acceleration = _acceleration.normalized();
	
	var _accel_coef:float = _WALK_ACCEL_COEF * _RUN_COEF if _is_running  else _WALK_ACCEL_COEF;
	_acceleration *= _accel_coef;
	
	if _is_jumping and WorldPhysics.get_depth(character.get_pos()) >  JUMP_DEPTH:
		_is_jumping = false;
	
	character.move_body(_acceleration);
	
	if WorldPhysics.is_in_outer_space(character.get_pos()):
		stateMachine.change_state(character.get_state(FirstPersonController.State.OUTER_FLYING));
	
	elif WorldPhysics.get_depth(character.get_pos()) < 0.0:
		stateMachine.change_state(character.get_state(FirstPersonController.State.INNER_FLYING));
	
	character.rotate_head(_GRAVITY_SMOOTH);
