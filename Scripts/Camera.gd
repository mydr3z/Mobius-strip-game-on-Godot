extends Camera3D

const lookSpeed:float = 2.0
const lookXlimit:float = 50.0

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var rotation = -event.relative.x * lookSpeed
		rotation.y += -event.relative.y * lookSpeed
		rotation.x = clamp(rotation.x, -lookXlimit, lookXlimit)
		self.rotate_x(rotation.y)
		rotate_y(rotation.x)
