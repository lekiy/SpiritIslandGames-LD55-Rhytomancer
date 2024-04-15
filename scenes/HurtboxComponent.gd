extends Area2D

signal hitTarget

func _on_hitbox_area_entered(area):
	if(area.has_method("damage")):
		var attack = Attack.new()
		attack.attack_damage = get_parent().attack_damage
		
		area.damage(attack)
		hitTarget.emit()
