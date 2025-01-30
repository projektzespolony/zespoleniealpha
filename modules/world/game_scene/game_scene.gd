class_name GameScene extends Node2D

var paused: bool = false

@onready var pause_menu_scene: Control = $PauseMenu
@onready var player = $"/root/Player"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		print("DEBUG: ESCAPE")
		pause_menu_scene.position = Player.position
		pause_menu()


func pause_menu() -> void:
	if paused:
		pause_menu_scene.hide()
		Engine.time_scale = 1
	else:
		pause_menu_scene.show()
		Engine.time_scale = 0

	paused = !paused
