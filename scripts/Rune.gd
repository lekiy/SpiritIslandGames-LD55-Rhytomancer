class_name Rune extends Sprite2D

@export var runeType = "DESTRUCTION"
# Called when the node enters the scene tree for the first time.
func updateType():
	var atlas: AtlasTexture = texture
	match runeType:
		"DESTRUCTION": atlas.region = Rect2(48, 0, 16, 16)
		"CREATION": atlas.region = Rect2(32, 0, 16, 16)
		"FORCE": atlas.region = Rect2(16, 0, 16, 16)
		"PROTECTION": atlas.region = Rect2(0, 0, 16, 16)

func _ready():
	updateType()
