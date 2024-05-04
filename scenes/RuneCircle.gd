extends Node2D

const rotation_speed = 30.0
var _rotation = 0.0

func _process(delta):
	_rotation += rotation_speed * delta
	for i in get_child_count():
		get_child(i).position = position + Vector2.RIGHT.rotated(deg_to_rad((360.0/get_child_count()) * i + _rotation)) * (get_child_count()*3)
