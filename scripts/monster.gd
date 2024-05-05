class_name Monster extends Node2D

var target
var speed = 60
@export var attack_damage = 4
@export var attack_move_speed = 120
@export var retreatSpeed = 60
@export var is_flying = false
@export var attack_speed = 4
var start_position

func _ready():
	$AttackTimer.wait_time = attack_speed
	$AttackTimeScaler/AttackTimeBar.max_value = attack_speed
	
func _process(delta):
	var angle = 0
	var direction = Vector2(1, 0).rotated(angle).normalized()
	if(target):
		angle = get_angle_to(target)
		direction = Vector2(1, 0).rotated(angle).normalized()
	
		global_position += speed*direction*delta
		if(global_position.distance_to(target) <= speed*delta):
			global_position = target
			target = null
	
	$AttackTimeScaler/AttackTimeBar.value = $AttackTimer.time_left
			

		
func useAttack():
	target = get_parent().player.global_position
	speed = attack_move_speed

func _on_hurtbox_component_hit_target(_target):
	speed = retreatSpeed
	target = start_position

func _on_has_died():
	if(get_parent().name == "Battle"):
		get_parent().monster = null
	queue_free()

func _on_hitbox_component_area_entered(area):
	if area.get_parent() is Player:
		$AttackTimer.wait_time = attack_speed
		$AttackTimer.start()
		
func get_hitbox():
	return $HitboxComponent


func _on_attack_timer_timeout():
	useAttack()
