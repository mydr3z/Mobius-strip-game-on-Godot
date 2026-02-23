extends Node3D

const NUM_OF_ITEMS:int = 1250;

var _terrain_item = preload("res://Prefabs/terItem.tscn");


func _instantiate_item(_pos_radians:float)->void:
	var _pos = Vector3(cos(_pos_radians), sin(_pos_radians), 0.0);
	_pos = _pos * WorldPhysics.get_terrain_radius();
	var _res = _terrain_item.instantiate();
	_res.position = _pos;
	_res.rotate(Vector3(cos(_pos_radians + PI/2.0), sin(_pos_radians + PI/2.0), 0.0), _pos_radians/2.0);
	add_child(_res);


func _ready()->void:
	var _step_radians = 2*PI / NUM_OF_ITEMS;
	for i in range(0, NUM_OF_ITEMS):
		_instantiate_item(i * _step_radians);
