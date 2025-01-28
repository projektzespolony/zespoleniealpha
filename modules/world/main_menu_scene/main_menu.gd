class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_button
@onready var options_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Options_button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_button
@export var start_level: PackedScene = preload("res://modules/world/game_scene/game_scene.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.visible = false
	start_button.button_up.connect(on_start_up)
	exit_button.button_up.connect(on_exit_up)

func on_start_up() -> void:
	Player.visible = true
	get_tree().change_scene_to_packed(start_level)

func on_exit_up() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
