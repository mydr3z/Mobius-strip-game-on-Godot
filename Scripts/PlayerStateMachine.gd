extends Node

class_name PlayerStateMachine

var _current_state:PlayerState


func initialize(startingState:PlayerState)->void:
	_current_state = startingState;
	startingState.enter();


func change_state(_new_state:PlayerState)->void:
	_current_state.exit();
	_current_state = _new_state;
	_new_state.enter();


func get_state()->PlayerState:
	return _current_state;
