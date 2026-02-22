extends Node

class_name PlayerStateMachine

var _currentState:PlayerState


func initialize(startingState:PlayerState):
	_currentState = startingState;
	startingState.enter();


func change_state(newState:PlayerState):
	_currentState.exit();
	_currentState = newState;
	newState.enter();


func get_state()->PlayerState:
	return _currentState;
