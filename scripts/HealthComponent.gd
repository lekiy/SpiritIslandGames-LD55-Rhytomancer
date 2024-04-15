class_name HealthComponent extends Node2D

@export var MAX_HEALTH := 20.0
@onready var splashText = preload("res://scenes/splash_number.tscn")
var health : float
signal has_died

func _ready():
	health = MAX_HEALTH
	
func damage(attack: Attack):
	health -= attack.attack_damage
	var splash = splashText.instantiate()
	get_parent().get_parent().add_child(splash)
	splash.global_position = global_position
	splash.get_node("Value").text = str(attack.attack_damage)
	if (health <= 0):
		has_died.emit()
		
func heal(amount):
	var splash = splashText.instantiate()
	get_parent().get_parent().add_child(splash)
	splash.global_position = global_position
	splash.get_node("Value").text = str(amount)
	if (health > MAX_HEALTH):
		health = MAX_HEALTH
