extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += 96*delta
	
func destory():
	queue_free()
