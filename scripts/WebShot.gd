extends Sprite2D

var fall_rate = 7
var velocity = Vector2(-160, -160);
var attack_damage

@onready var web_fx_scene = preload("res://scenes/Enemy/webbed_fx.tscn")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += fall_rate
	global_position += velocity*delta
	
func _on_hit_target(target):
	var web_fx = web_fx_scene.instantiate()
	target.get_parent().add_child(web_fx)
	queue_free()
