extends Node2D

@onready var _projectile = $Projectile
@onready var spike = $Spike
@onready var hurtboxComponent = $HurtboxComponent/CollisionShape2D2

@export var speed = 150
@export var max_damage = 16
var attack_damage = 0

func _ready():
	spike.stop()
	spike.hide()
	hurtboxComponent.disabled = true

func _process(delta):
	global_position+=Vector2.RIGHT*speed*delta


func _on_projectile_area_entered(area):
	_projectile.queue_free()
	speed = 0
	global_position.x = area.global_position.x
	spike.show()
	spike.play()
	hurtboxComponent.set_deferred("disabled", false)


func _on_spike_animation_finished():
	queue_free()
