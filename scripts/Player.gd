class_name Player extends Node2D

var fireball = preload("res://scenes/fireball.tscn")
var healFX = preload("res://scenes/heal_fx.tscn")

@onready var battle = get_parent()

var hasTarget = false
var speed = 20

func _process(delta):
	if(!hasTarget):
		var direction = Vector2(1, 0)
		position += speed*direction*delta

func _on_cast_spell_signal(runes, strength):
	if(runes == [Rune.type.DESTRUCTION, Rune.type.FORCE, Rune.type.DESTRUCTION]): #Fireball
		if(battle.monster):
			var target = battle.monster.get_node("HitboxComponent")
			var spell = fireball.instantiate()
			spell.target = target
			spell.speed = global_position.distance_to(target.global_position)*2
			spell.attack_damage = round(spell.maxDamage * strength)
			add_child(spell)
	if(runes == [Rune.type.CREATION, Rune.type.PROTECTION, Rune.type.PROTECTION, Rune.type.CREATION]):
		var spell = healFX.instantiate()
		$HealthComponent.heal(round(spell.maxEffect * strength))
		add_child(spell)
		


func _on_battle_area_entered(area):
	if(area.get_parent() is Monster):
		hasTarget = true


func _on_battle_area_exited(area):
	if(area.get_parent() is Monster):
		hasTarget = false
