class_name RhythmBar extends Sprite2D

var beatOrb = preload("res://scenes/beat.tscn")
var fakeBeat = preload("res://scenes/fake_beat.tscn")
var runeScene = preload("res://scenes/rune.tscn")
var timingLabel = preload("res://scenes/timing_lable.tscn")

var perfect = false
var good = false
var fine = false
var currentNote = null

var runesStored = []
var runeIcons = []
var spellStrength = 0

var is_webbed = false

@onready var player = get_node("../../Player")

signal castSpellSignal(runes)

func _unhandled_input(event):
	if(checkCasts(event)):
		if(checkCastsPressed(event)):
			if(currentNote != null):
				currentNote.get_parent().queue_free()
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
				reset()
				
func storeRune(runeType):
	var instance = runeScene.instantiate()
	get_parent().get_child(1).add_child(instance)
	instance.runeType = runeType
	runesStored.push_back(runeType)
	instance.updateType()
	runeIcons.push_back(instance)
	var label = timingLabel.instantiate()
	if(perfect):
		spellStrength+=1
		label.text = "Perfect!"
	elif good:
		spellStrength+=0.75
		label.text = "Good"
	elif fine:
		spellStrength+=0.5
		label.text = "Okay"
	add_child(label)
	
func castSpell():
	if(len(runesStored) > 0):
		castSpellSignal.emit(runesStored, spellStrength/len(runesStored))
		spellStrength = 0
		runesStored = []
		for rune in runeIcons:
			rune.queue_free()
		runeIcons = []
	
func wiffSpell():
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
	
func reset():
	perfect = false
	good = false
	fine = false
	currentNote = null


func _on_perfect_timing_area_entered(area):
	if(area.is_in_group("note")):
		perfect = true


func _on_perfect_timing_area_exited(area):
	if(area.is_in_group("note")):
		perfect = false


func _on_good_timing_area_entered(area):
	if(area.is_in_group("note")):
		good = true


func _on_good_timing_area_exited(area):
	if(area.is_in_group("note")):
		good = false


func _on_fine_timing_area_entered(area):
	if(area.is_in_group("note")):
		fine = true
		currentNote = area


func _on_fine_timing_area_exited(area):
	if(area.is_in_group("note")):
		fine = false
		currentNote = null


func _on_conductor_beat_signal(beat_position):
	if is_webbed:
		is_webbed = false
		var instance = fakeBeat.instantiate()
		add_child(instance)
		instance.position.x = -96
	else:
		var instance = beatOrb.instantiate()
		add_child(instance)
		instance.position.x = -96
	
