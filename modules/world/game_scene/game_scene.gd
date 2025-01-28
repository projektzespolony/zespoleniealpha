extends Node2D

@onready var pause_menu_scene: Control = $PauseMenu
var paused: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
