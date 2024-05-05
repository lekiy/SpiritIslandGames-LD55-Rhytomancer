extends Monster

@export var bat_count = 3

@onready var bat_scene = preload("res://scenes/Enemy/bat.tscn")

signal notify_swarm(area)

var player

func _ready():
	player = get_parent().player
	
	for i in bat_count:
		var bat = bat_scene.instantiate()
		add_child(bat)
		bat.global_position = global_position+Vector2(0, 10).rotated(deg_to_rad(360.0/bat_count*i))
		bat.start_position = player.global_position+Vector2(192, -40)+Vector2(0, 10).rotated(deg_to_rad(360.0/bat_count*i))
		notify_swarm.connect(bat._on_hitbox_component_area_entered)
		#bat.beatsUntilAttack -= i*2

func _process(_delta):
	var has_monster = false
	for child in get_children():
		if child is Monster:
			has_monster = true
	if not has_monster:
		_on_has_died()


func _on_hitbox_component_area_entered(area):
	notify_swarm.emit(area)

func get_hitbox():
	return get_child(1).get_node("HitboxComponent")
