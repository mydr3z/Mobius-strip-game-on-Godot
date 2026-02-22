extends Node3D

const NUM_OF_ITEMS:int = 1250

var terrainItem = preload("res://Prefabs/terItem.tscn")

func instantiateItem(posRadians:float):
	var pos = Vector3(cos(posRadians), sin(posRadians), 0.0)
	pos = pos * WorldPhysics.get_terrain_radius()
	var res = terrainItem.instantiate()
	res.position = pos
	#var degreesPos:float = rad_to_deg(posRadians)
	res.rotate(Vector3(cos(posRadians + PI/2.0), sin(posRadians + PI/2.0), 0.0), posRadians/2.0)
	add_child(res)

func _ready():
	var stepRadians = 2*PI / NUM_OF_ITEMS
	for i in range(0, NUM_OF_ITEMS):
		instantiateItem(i * stepRadians)
