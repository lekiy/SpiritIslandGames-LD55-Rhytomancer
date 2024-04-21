extends Area2D

signal hitTarget(target)

func _on_hitbox_area_entered(area):
	if(area.has_method("damage")):
		var attack_damage = get_parent().attack_damage
		
		area.damage(attack_damage)
		hitTarget.emit(area)
