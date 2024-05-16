class_name Enemy

extends Node

@export var health: int = 5

func damage(amount: int) -> void:
	health -= amount
