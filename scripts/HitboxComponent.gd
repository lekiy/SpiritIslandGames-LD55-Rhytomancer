class_name HitboxComponent extends Area2D

@export var health_component : Node

func damage(attack_damage):
	if health_component:
		health_component.damage(attack_damage)
		
