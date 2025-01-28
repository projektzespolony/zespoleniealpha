extends Node2D

@onready var pause_menu_scene: Control = $PauseMenu
var paused: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu_scene.position = Player.position
		pause_menu()

func pause_menu():
	if paused:
		pause_menu_scene.hide()
		Engine.time_scale = 1
	else:
		pause_menu_scene.show()
		Engine.time_scale = 0
	
	paused = !paused
