extends Sprite2D

@onready var note_scene = preload("res://scenes/beat.tscn")

var clock_rotation = 0.0

func _ready():
	SignalBus.beat_signal.connect(_on_beat)


func _process(delta):
	clock_rotation += 45.0/SignalBus.BEATS_PER_SECOND*delta
	$ClockHand.rotation = deg_to_rad(clock_rotation)

func _on_beat(_beat_count):
	var resync = round(clock_rotation/45.0)*45
	if(resync >= 360):
		resync -= 360
	clock_rotation = resync
	
	var note = note_scene.instantiate()
	add_child(note)
	note.position = Vector2.RIGHT.rotated(deg_to_rad(clock_rotation - 45.0)).normalized()*25
