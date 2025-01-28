class_name MainMenu
extends Control

@export var start_level: PackedScene = preload("res://modules/world/game_scene/game_scene.tscn")


func _ready() -> void:
	Engine.time_scale = 0
	Player.visible = false

func _on_start_button_button_up() -> void:
	Engine.time_scale = 1
	Player.visible = true
	get_tree().change_scene_to_packed(start_level)

func _on_exit_button_button_up() -> void:
	get_tree().quit()
