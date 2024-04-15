class_name Rune extends TextureRect

enum type { DESTRUCTION, CREATION, FORCE, PROTECTION }
@export var runeType = type.DESTRUCTION
# Called when the node enters the scene tree for the first time.
func updateType():
	var atlas: AtlasTexture = texture
	match runeType:
		type.DESTRUCTION: atlas.region = Rect2(0, 0, 16, 16)
		type.CREATION: atlas.region = Rect2(16, 0, 16, 16)
		type.FORCE: atlas.region = Rect2(16, 16, 16, 16)
		type.PROTECTION: atlas.region = Rect2(0, 16, 16, 16)

func _ready():
	updateType()