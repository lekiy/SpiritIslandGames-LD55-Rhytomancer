class_name Player extends Node2D

var fireball = preload("res://scenes/Spell/fireball.tscn")
var healFX = preload("res://scenes/Spell/heal_fx.tscn")
var earth_spike = preload("res://scenes/Spell/earth_spike.tscn")

@onready var battle = get_parent()

var hasTarget = false
var target = null
var speed = 20

func _process(delta):
	if(!hasTarget):
		var direction = Vector2(1, 0)
		position += speed*direction*delta


func _on_cast_spell_signal(runes, strength):
	if(runes == [Rune.type.DESTRUCTION, Rune.type.FORCE, Rune.type.DESTRUCTION]): #Fireball
		if(battle.monster):
			var target = battle.monster.get_hitbox()
			var spell = fireball.instantiate()
			spell.target = target
			spell.speed = 100.0
			spell.attack_damage = round(spell.maxDamage * strength)
			spell.global_position = global_position
			get_parent().add_child(spell)
	if(runes == [Rune.type.CREATION, Rune.type.PROTECTION, Rune.type.PROTECTION, Rune.type.CREATION]):
		var spell = healFX.instantiate()
		$HealthComponent.heal(round(spell.maxEffect * strength))
		add_child(spell)
	if(runes == [Rune.type.PROTECTION, Rune.type.DESTRUCTION, Rune.type.CREATION, Rune.type.PROTECTION]):
		var spell = earth_spike.instantiate()
		spell.global_position = Vector2(global_position.x+20, global_position.y+5)
		spell.attack_damage = round(spell.max_damage * strength)
		get_parent().add_child(spell)
		


func _on_battle_area_entered(area):
	if(area.get_parent() is Monster):
		target = area
		hasTarget = true


func _on_battle_area_exited(area):
	if(area.get_parent() is Monster):
		if(area == target):
			target = null
			hasTarget = false
