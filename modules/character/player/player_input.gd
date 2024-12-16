class_name PlayerInput
extends Node

var player: Character


func _init(_player: Character) -> void:
	player = _player


func _physics_process(delta: float) -> void:
	handle_input(delta)


func handle_input(delta: float) -> void:
	var global_mouse_position: Vector2 = player.get_global_mouse_position()
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")

	player.look_at(global_mouse_position)

	var velocity: Vector2 = (
		input_direction
		* player.get_movement_speed_modifier()
		* WorldContants.MOVEMENT_SPEED_MULTIPLIER
		* delta
	)

	player.velocity = velocity
	player.move_and_slide()
