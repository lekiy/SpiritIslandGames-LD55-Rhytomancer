class_name projectile extends AnimatedSprite2D

var target : Vector2
@export var speed : float
@export var maxDamage = 6
var attack_damage

@onready var explosionFX = preload("res://scenes/explosion.tscn")

func _process(delta):
	var angle = 0
	var direction = Vector2(1, 0).rotated(angle).normalized()
	
	if(target):
		angle = get_angle_to(target)
		rotation = angle
		direction = Vector2(1, 0).rotated(angle).normalized()
	
	position += speed*direction*delta
		
		
func _on_hit_target(_target):
	var explosion = explosionFX.instantiate()
	explosion.global_position = global_position+Vector2(16, 0)
	get_parent().get_parent().add_child(explosion)
	queue_free()
