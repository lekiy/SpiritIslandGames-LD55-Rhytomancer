extends Node2D

@onready var rhythmBar = $HUD/RhythmBar
@onready var conductor = $Conductor
@onready var player : Player = $Player
@onready var monster : Monster = null

@onready var wolf = preload("res://scenes/monster.tscn")

func _ready():
	$Conductor.play_with_beat_offset(2)

func _process(delta):
	if(!monster):
		var newMonster = wolf.instantiate()
		add_child(newMonster)
		newMonster.position = player.global_position+Vector2(192, 0)
		conductor.beat_signal.connect(newMonster._on_conductor_beat_signal)
		newMonster.startPosition = newMonster.global_position
		monster = newMonster
