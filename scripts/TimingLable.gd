extends Label


var opacity = 1
var floatSpeed = 5
var fade = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y-=floatSpeed*delta
	if(fade):
		opacity -= 1*delta
	if(opacity <= 0): queue_free()
	var col = Color(1, 1, 1, opacity)
	set("theme_override_colors/font_color", col)


func _on_timer_timeout():
	fade = true
