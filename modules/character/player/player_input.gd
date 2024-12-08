class_name PlayerInput
extends Node

var player: Character


func _init(_player: Character):
	player = _player


func _physics_process(delta):
	handle_input(delta)


func handle_input(delta):
	var global_mouse_position = player.get_global_mouse_position()
	var input_direction = Input.get_vector("left", "right", "up", "down")

	player.look_at(global_mouse_position)

	var velocity = (
		input_direction
		* player.get_movement_speed_modifier()
		* WorldContants.MOVEMENT_SPEED_MULTIPLIER
		* delta
	)

	player.velocity = velocity
	player.move_and_slide()
