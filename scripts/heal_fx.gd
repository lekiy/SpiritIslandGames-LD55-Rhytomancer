extends Node2D

@export var maxEffect = 8

func _on_timer_timeout():
	queue_free()
