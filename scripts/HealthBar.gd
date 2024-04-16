extends TextureProgressBar

@export var player: Player
var healthComponent

func _ready():
	healthComponent = player.get_node("HealthComponent")
	healthComponent.on_health_changed.connect(_on_health_changed_signal)
	_on_health_changed_signal()
#	?max_value = healthComponent.MAX_HEALTH
	
	
func _on_health_changed_signal():
	value = healthComponent.health*100/healthComponent.MAX_HEALTH
	
