class_name FirstPersonController

extends Node3D

const LITTLE:float = 0.01

const WALK_SPEED:float = 2.0
const SMOOTH_COEF:float = 0.1

var last_gravity = Vector3()

var lookSpeed:float = 2.0
var lookXLimit:float = 50.0

var velocity = Vector3(0,0,0)

enum State{OUTER_FLYING, INNER_FLYING, WALKING}

var stateMachine:PlayerStateMachine = PlayerStateMachine.new()
var outerFlying:OuterSpaceState = OuterSpaceState.new(self, stateMachine);
var walking:WalkingState = WalkingState.new(self, stateMachine);
var innerFly:InnerFlyState = InnerFlyState.new(self, stateMachine)

var _head:Node3D

var _rotation_x:float = 0.0
var _rotation_y:float = 0.0

func _ready():
	stateMachine.initialize(outerFlying);
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	last_gravity = WorldPhysics.get_local_gravity(position);
	_head = $head;


func _process(delta: float) -> void:
	print(stateMachine);
	stateMachine.get_state().handle_input();
	stateMachine.get_state().move_update();


func get_pos() -> Vector3:
	return position;


func move_body(walkAccel:Vector3):
	velocity += WorldPhysics.get_total_accel(position, velocity) * get_process_delta_time();
	velocity += walkAccel * get_process_delta_time();
	position += velocity * get_process_delta_time();


func rotate_head(gravitySmoothing:float = SMOOTH_COEF):
	var _gravity:Vector3 = WorldPhysics.get_local_gravity(position);
	var _is_opposite:bool = true;
	
	while(_is_opposite):
		if((_gravity + last_gravity).length_squared() > LITTLE):
			_is_opposite = false;
			
		else:
			last_gravity += Vector3(randf(),randf(),randf()) * LITTLE;
			last_gravity = last_gravity.normalized();
			
	_gravity = last_gravity.slerp(_gravity, gravitySmoothing * get_process_delta_time());
	
	var targetDir:Vector3 = (-_gravity).cross(_gravity - Vector3(0.2, 0.2, 0.2));
	var target = position + targetDir;
	look_at(target, -_gravity);
	last_gravity = _gravity;
	
	var mouse_pos = get_viewport().get_mouse_position();
	var screen_size = get_viewport().get_visible_rect().size;
	var _x_axis = (mouse_pos.x / screen_size.x) * 2.0 - 1.0;
	var _y_axis = (mouse_pos.y / screen_size.y) * 2.0 - 1.0;
	_rotation_y += _x_axis * lookSpeed;
	_rotation_x -= _y_axis * lookSpeed;
	
	_rotation_x = clamp(_rotation_x, -lookXLimit, lookXLimit);
	_head.rotation.x = _rotation_x;
	rotation.y = _rotation_y;
	

func get_state(stateName:State)->PlayerState:
	match stateName:
		State.OUTER_FLYING:
			return outerFlying
		State.WALKING:
			return walking
		State.INNER_FLYING:
			return innerFly
	return walking
