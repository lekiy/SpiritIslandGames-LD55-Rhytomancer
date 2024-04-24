extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	position.x += 192*SignalBus.BEATS_PER_SECOND*delta
	
func destory():
	queue_free()
