class_name Player extends Node2D

var fireball = preload("res://scenes/Spell/fireball.tscn")
var healFX = preload("res://scenes/Spell/heal_fx.tscn")
var earth_spike = preload("res://scenes/Spell/earth_spike.tscn")
var runeScene = preload("res://scenes/rune.tscn")

@onready var battle = get_parent()

var hasTarget = false
var target = null
var speed = 20
var runesStored = []
var runeIcons = []
var spellStrength = 0

func _process(delta):
	if(!hasTarget):
		var direction = Vector2(1, 0)
		position += speed*direction*delta


func _on_cast_spell_signal(runes, strength):
	if(runes == [Rune.type.DESTRUCTION, Rune.type.FORCE, Rune.type.DESTRUCTION]): #Fireball
		if(battle.monster):
			var spell_target = battle.monster.get_hitbox()
			var spell = fireball.instantiate()
			spell.target = spell_target
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
		
func _unhandled_input(event):
	if(checkCasts(event)):
		if(checkCastsPressed(event)):
				if(event.is_action("CastUp")):
					storeRune(Rune.type.CREATION)
				if(event.is_action("CastDown")):
					storeRune(Rune.type.DESTRUCTION)
				if(event.is_action("CastLeft")):
					storeRune(Rune.type.PROTECTION)
				if(event.is_action("CastRight")):
					storeRune(Rune.type.FORCE)
				if(event.is_action("CompleteSpell")):
					castSpell()
				
func storeRune(runeType):
	var instance = runeScene.instantiate()
	$RuneCircle.add_child(instance)
	instance.runeType = runeType
	runesStored.push_back(runeType)
	instance.updateType()
	runeIcons.push_back(instance)
	spellStrength+=1
	
func castSpell():
	if(len(runesStored) > 0):
		_on_cast_spell_signal(runesStored, float(spellStrength)/len(runesStored))
		spellStrength = 0
		runesStored = []
		for rune in runeIcons:
			rune.queue_free()
		runeIcons = []
	

func checkCasts(event):
	if(event.is_action("CastUp") || event.is_action("CastDown") || event.is_action("CastLeft") || event.is_action("CastRight") || event.is_action("CompleteSpell")):
		return true
	return false
	
func checkCastsPressed(event):
	if(event.is_action_pressed("CastUp", false) || event.is_action_pressed("CastDown", false) || event.is_action_pressed("CastLeft", false) || event.is_action_pressed("CastRight", false) || event.is_action_pressed("CompleteSpell", false)):
		return true
	return false

func _on_battle_area_entered(area):
	if(area.get_parent() is Monster):
		target = area
		hasTarget = true


func _on_battle_area_exited(area):
	if(area.get_parent() is Monster):
		if(area == target):
			target = null
			hasTarget = false
