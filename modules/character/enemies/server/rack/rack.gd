class_name Rack extends Node2D

@export var server: Node2D


func take_damage(damage: int) -> void:
	server.take_damage(damage)
