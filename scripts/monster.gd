class_name Monster extends Node2D

@export var beatsPerAttack = 6
var beatsUntilAttack = beatsPerAttack
@onready var attackTimeLabel : Label = $AttackTimeLabel

var target
var speed = 60
@export var attack_damage = 4
@export var attackSpeed = 120
@export var retreatSpeed = 60
var startPosition
var canAttack = false

func _ready():
	startPosition = global_position
	attackTimeLabel.show()
	attackTimeLabel.text = str(beatsUntilAttack)
	
func _process(delta):
	var angle = 0
	var direction = Vector2(1, 0).rotated(angle).normalized()
	if(target):
		angle = get_angle_to(target)
		direction = Vector2(1, 0).rotated(angle).normalized()
	
		position += speed*direction*delta
		if(position.distance_to(target) < speed*delta):
			position = target
			target = null

func _on_conductor_beat_signal(_beat_position):
	if(canAttack):
		beatsUntilAttack-=1
		attackTimeLabel.text = str(beatsUntilAttack)
		if(beatsUntilAttack <= 0):
			useAttack()
			beatsUntilAttack = beatsPerAttack
		
func useAttack():
	target = get_parent().player.global_position
	speed = attackSpeed

func _on_hurtbox_component_hit_target():
	speed = retreatSpeed
	target = startPosition

func _on_has_died():
	get_parent().monster = null
	queue_free()

func _on_hitbox_component_area_entered(area):
	if area.get_parent() is Player:
		canAttack = true
