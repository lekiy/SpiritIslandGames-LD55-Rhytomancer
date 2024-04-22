extends Sprite2D

@export var effect_duration_in_beats = 4
@onready var conductor = get_node("../../Conductor")
var beats = 0

func _ready():
	conductor.beat_signal.connect(_on_conductor_beat_signal)
	

func _on_conductor_beat_signal(_beat_position):
	beats+=1
	if beats >= effect_duration_in_beats:
		queue_free()
