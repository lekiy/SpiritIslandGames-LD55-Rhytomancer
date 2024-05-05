extends Node2D

@onready var conductor = $Conductor
@onready var player : Player = $Player
@onready var monster : Monster = null

@onready var wolf = preload("res://scenes/Enemy/wolf.tscn")
@onready var giant_spider = preload("res://scenes/Enemy/giant_spider.tscn")
@onready var bat_swarm = preload("res://scenes/Enemy/bat_swarm.tscn")

func _ready():
	pass
	#$Conductor.play_with_beat_offset(2)

func _process(_delta):
	if(!monster):
		var monster_scene
		match(randi() % 3):
		#match(0):
			0:
				monster_scene = wolf
			1:
				monster_scene = giant_spider
			2:
				monster_scene = bat_swarm	
		spawn_monster(monster_scene)


func spawn_monster(monster_scene):
		var newMonster = monster_scene.instantiate()
		add_child(newMonster)
		newMonster.global_position = player.global_position+Vector2(192, 0)
		if newMonster.is_flying :
			newMonster.global_position = player.global_position+Vector2(192, -40)
		newMonster.start_position = newMonster.global_position
		monster = newMonster
