extends Node

class_name PlayerStateMachine

var _current_state:PlayerState


func initialize(startingState:PlayerState):
	_current_state = startingState;
	startingState.enter();


func change_state(newState:PlayerState):
	_current_state.exit();
	_current_state = newState;
	newState.enter();


func get_state()->PlayerState:
	return _current_state;
