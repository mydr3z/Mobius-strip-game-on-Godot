extends PlayerState

class_name InnerFlyState


func enter()->void:
	super();


func exit()->void:
	super();


func handle_input()->void:
	pass;


func move_update()->void:
	super.move_update();
	character.move_body(Vector3.ZERO);
	
	if WorldPhysics.get_depth(character.get_pos()) >= 0.0 and !WorldPhysics.is_in_outer_space(character.get_pos()):
		stateMachine.change_state(character.get_state(FirstPersonController.State.WALKING));
	
	if WorldPhysics.is_in_outer_space(character.get_pos()):
		stateMachine.change_state(character.get_state(FirstPersonController.State.OUTER_FLYING));
	character.rotate_head();
