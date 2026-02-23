extends Node

var WORLD_AXIS:Vector3 = Vector3(0,0,1.0);

var GROUND_MARGIN_METRES:float = 0.5;
var SQ_HALF_TER_WIDTH:float = 25.0;
var GROUND_ELASTIC_COEF:float = -1500;
var GRAVITY_COEF:float = 5;
var MAX_DRAG_COEF:float = -12;
var GO_HOME_COEF:float = 0.004;
var GO_HOME_POINT_H:float = 2.0;

var _terrain_radius:float = 20.0;


func get_terrain_radius()->float:
	return _terrain_radius;


func get_total_accel(_position:Vector3, _velocity:Vector3)->Vector3:
	var _depth:float = get_depth(_position);
	
	if is_in_outer_space(_position):
		return go_home_accel(_position);
	
	var _half_ter_width:float = sqrt(SQ_HALF_TER_WIDTH);
	var _drag_coef:float = MAX_DRAG_COEF if get_depth(_position) > 0.0 else MAX_DRAG_COEF * pow((_half_ter_width-_get_unsigned_local_height(_position)) / _half_ter_width, 4);
	var _drag_accel:Vector3 = _velocity * _drag_coef;
	var _local_gravity_dir:Vector3 = get_local_gravity(_position);
	
	if _depth > 0:
		return _local_gravity_dir * (GROUND_ELASTIC_COEF * _depth + GRAVITY_COEF) + _drag_accel;
	return Vector3(0,0,0);


func get_depth(_position:Vector3)->float:
	return GROUND_MARGIN_METRES - _get_unsigned_local_height(_position);

func go_home_accel(_position:Vector3)->Vector3:
	var _proj_on_world_plane:Vector3 = _position;;
	_proj_on_world_plane.z = 0.0;
	_proj_on_world_plane = _proj_on_world_plane.normalized();
	
	var _grnd_orig:Vector3 = _proj_on_world_plane * _terrain_radius;
	var _target:Vector3 = _grnd_orig - get_local_gravity(_position) * GO_HOME_POINT_H;
	
	return (_target-_position) * GO_HOME_COEF;

func is_in_outer_space(_position:Vector3)->bool:
	var _proj_on_world_plane:Vector3 = _position;
	_proj_on_world_plane.z = 0.0;
	_proj_on_world_plane = _proj_on_world_plane.normalized();
	
	var _grnd_orig:Vector3 = _proj_on_world_plane * _terrain_radius;
	
	return ((_position - _grnd_orig).length()) ** 2 > SQ_HALF_TER_WIDTH;

func _get_unsigned_local_height(_position:Vector3) -> float:
	var _proj_on_world_plane = _position;
	_proj_on_world_plane.z = 0.0;
	_proj_on_world_plane = _proj_on_world_plane.normalized();
	
	var _world_angle_cos:float = Vector3(1.0,0.0,0.0).dot(_proj_on_world_plane);
	var _world_angle:float = acos(_world_angle_cos);
	
	if _position.y  < 0.0:
		_world_angle = PI * 2 - _world_angle;
	
	var _grnd_rotation_axis:Vector3 = (WORLD_AXIS.cross(_proj_on_world_plane)).normalized();
	var _grnd_normal:Vector3 = _proj_on_world_plane;
	_grnd_normal = _grnd_normal.rotated(_grnd_rotation_axis, _world_angle);
	var _grnd_orig:Vector3 = _proj_on_world_plane * _terrain_radius;
	var _grnd_to_pos:Vector3 = _position - _grnd_orig;
	
	return abs(_grnd_to_pos.dot(_grnd_normal));

func get_local_gravity(_position:Vector3)->Vector3:
	var _proj_on_world_plane:Vector3 = _position;
	_proj_on_world_plane.z = 0.0;
	_proj_on_world_plane = _proj_on_world_plane.normalized();
	
	var _world_angle_cos:float = Vector3(1.0, 0, 0).dot(_proj_on_world_plane);
	var _world_angle = acos(_world_angle_cos);
	
	if _position.y < 0.0:
		_world_angle = PI * 2 - _world_angle;
	
	var _grnd_rotation_axis:Vector3 = (WORLD_AXIS.cross(_proj_on_world_plane)).normalized();
	var _grnd_normal:Vector3 = _proj_on_world_plane;
	print(_proj_on_world_plane);
	print(_grnd_rotation_axis);
	_grnd_normal = _grnd_normal.rotated(_grnd_rotation_axis, _world_angle);
	var _grnd_orig:Vector3 = _proj_on_world_plane * _terrain_radius;
	var _grnd_to_pos:Vector3 = _position - _grnd_orig;
	var posToGrndDist:float = _grnd_to_pos.dot(_grnd_normal);
	var gravityDirection:Vector3 = -posToGrndDist * _grnd_normal;
	
	return gravityDirection.normalized() ;
