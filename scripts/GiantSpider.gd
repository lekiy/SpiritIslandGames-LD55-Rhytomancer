extends Monster

@onready var web_shot_scene = preload("res://scenes/Enemy/web_shot.tscn")

func _process(_delta):
	if(target):
		var web_shot = web_shot_scene.instantiate()
#		web_shot.target = target
#		web_shot.speed = 100.0
		web_shot.attack_damage = attack_damage
		web_shot.global_position = $HitboxComponent.global_position
		get_parent().add_child(web_shot)
		target = null

		
func useAttack():
	target = get_parent().player.global_position

