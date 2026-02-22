extends Node3D


func _physics_process(delta: float) -> void:
	rotate(Vector3(0,1, 0), 1*delta)
