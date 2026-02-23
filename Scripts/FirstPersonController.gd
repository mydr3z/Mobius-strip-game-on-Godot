class_name FirstPersonController

extends Node3D

const LITTLE:float = 0.01;
const WALK_SPEED:float = 2.0;
const SMOOTH_COEF:float = 0.1;

enum State{OUTER_FLYING, INNER_FLYING, WALKING};

var state_machine:PlayerStateMachine = PlayerStateMachine.new();

var _outer_flying:OuterSpaceState = OuterSpaceState.new(self, state_machine);
var _walking:WalkingState = WalkingState.new(self, state_machine);
var _inner_fly:InnerFlyState = InnerFlyState.new(self, state_machine);

var _head:Node3D;

var _rotation_x:float = 0.0;
var _rotation_y:float = 0.0;
var _last_gravity:Vector3 = Vector3();
var _look_speed:float = 2.0;
var _look_x_limit:float = 50.0;
var _velocity:Vector3 = Vector3(0,0,0);


func _ready() -> void:
	state_machine.initialize(_outer_flying);
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	_last_gravity = WorldPhysics.get_local_gravity(position);
	_head = $head;


func _process(delta: float) -> void:
	print(state_machine);
	state_machine.get_state().handle_input();
	state_machine.get_state().move_update();


func get_pos() -> Vector3:
	return position;


func move_body(_walk_accel:Vector3) -> void:
	_velocity += WorldPhysics.get_total_accel(position, _velocity) * get_process_delta_time();
	_velocity += _walk_accel * get_process_delta_time();
	position += _velocity * get_process_delta_time();


func rotate_head(_gravity_smoothing:float = SMOOTH_COEF) -> void:
	var _gravity:Vector3 = WorldPhysics.get_local_gravity(position);
	var _is_opposite:bool = true;
	
	while(_is_opposite):
		if((_gravity + _last_gravity).length_squared() > LITTLE):
			_is_opposite = false;
			
		else:
			_last_gravity += Vector3(randf(),randf(),randf()) * LITTLE;
			_last_gravity = _last_gravity.normalized();
			
	_gravity = _last_gravity.slerp(_gravity, _gravity_smoothing * get_process_delta_time());
	
	var _target_dir:Vector3 = (-_gravity).cross(_gravity - Vector3(0.2, 0.2, 0.2));
	var _target = position + _target_dir;
	look_at(_target, -_gravity);
	_last_gravity = _gravity;
	
	var _mouse_pos = get_viewport().get_mouse_position();
	var _screen_size = get_viewport().get_visible_rect().size;
	var _x_axis = (_mouse_pos.x / _screen_size.x) * 2.0 - 1.0;
	var _y_axis = (_mouse_pos.y / _screen_size.y) * 2.0 - 1.0;
	_rotation_y += _x_axis * _look_speed;
	_rotation_x -= _y_axis * _look_speed;
	
	_rotation_x = clamp(_rotation_x, -_look_x_limit, _look_x_limit);
	_head.rotation.x = _rotation_x;
	rotation.y = _rotation_y;


func get_state(_state_name:State)->PlayerState:
	match _state_name:
		State.OUTER_FLYING:
			return _outer_flying
		State.WALKING:
			return _walking
		State.INNER_FLYING:
			return _inner_fly
	return _walking
