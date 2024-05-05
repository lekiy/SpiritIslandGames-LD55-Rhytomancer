class_name Player extends Node2D

var fireball = preload("res://scenes/Spell/fireball.tscn")
var healFX = preload("res://scenes/Spell/heal_fx.tscn")
var earth_spike = preload("res://scenes/Spell/earth_spike.tscn")
var runeScene = preload("res://scenes/rune.tscn")

@onready var battle = get_parent()

var hasTarget = false
var target = null
var speed = 20
var runesStored = {"DESTRUCTION": 0, "CREATION": 0, "FORCE": 0, "PROTECTION": 0}
var runeIcons = []
var rune_queue = []
var spellStrength = 0
var charge = 0
var charge_time = 0.75

func _ready():
	$RuneChargeScaler/RuneChargeBar.max_value = charge_time

func _process(delta):
	$RuneChargeScaler/RuneChargeBar.value = charge
	
	if(!hasTarget):
		var direction = Vector2(1, 0)
		position += speed*direction*delta
		
	if Input.is_action_pressed("CastDown"):
		handle_charge_rune("DESTRUCTION", delta)
	elif Input.is_action_pressed("CastUp"):
		handle_charge_rune("CREATION", delta)
	elif Input.is_action_pressed("CastRight"):
		handle_charge_rune("FORCE", delta)
	elif Input.is_action_pressed("CastLeft"):
		handle_charge_rune("PROTECTION", delta)
	else:
		charge = 0
	
	if Input.is_action_just_pressed("CompleteSpell"):
		castSpell()
		
		
		
func handle_charge_rune(rune, delta):
	charge += delta
	if(charge >= charge_time):
			charge = 0
			storeRune(rune)
			

func _on_cast_spell_signal(runes, strength):
	if(runes == {"DESTRUCTION": 2, "CREATION": 0, "FORCE": 1, "PROTECTION": 0}): #Fireball
		if(battle.monster):
			var spell_target = battle.monster.get_hitbox()
			var spell = fireball.instantiate()
			spell.target = spell_target
			spell.speed = 100.0
			spell.attack_damage = round(spell.maxDamage * strength)
			spell.global_position = global_position
			get_parent().add_child(spell)
	if(runes == {"DESTRUCTION": 0, "CREATION": 2, "FORCE": 0, "PROTECTION": 2}):
		var spell = healFX.instantiate()
		$HealthComponent.heal(round(spell.maxEffect * strength))
		add_child(spell)
	if(runes == {"DESTRUCTION": 2, "CREATION": 1, "FORCE": 0, "PROTECTION": 2}):
		var spell = earth_spike.instantiate()
		spell.global_position = Vector2(global_position.x+20, global_position.y+5)
		spell.attack_damage = round(spell.max_damage * strength)
		get_parent().add_child(spell)
		

func storeRune(runeType):
	var instance = runeScene.instantiate()
	$RuneCircle.add_child(instance)
	instance.runeType = runeType
	runesStored[runeType] += 1
	instance.updateType()
	runeIcons.push_back(instance)
	spellStrength+=1
	
func castSpell():
	if(len(runesStored) > 0):
		_on_cast_spell_signal(runesStored, float(spellStrength)/len(runesStored))
		spellStrength = 0
		reset_runes()
		
		
func reset_runes():
	runesStored = {"DESTRUCTION": 0, "CREATION": 0, "FORCE": 0, "PROTECTION": 0}
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


func _on_rune_queue_timer_timeout():
	if len(rune_queue) > 0:
		
		$RuneQueueTimer.start()
