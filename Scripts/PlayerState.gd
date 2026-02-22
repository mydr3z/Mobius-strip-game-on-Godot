class_name PlayerState

extends Node

var character:FirstPersonController
var stateMachine:PlayerStateMachine


func _init(init_character:FirstPersonController, init_stateMachine:PlayerStateMachine):
	self.character = init_character
	self.stateMachine = init_stateMachine


func enter():
	return


func handle_input():
	return


func move_update():
	return


func exit():
	return
