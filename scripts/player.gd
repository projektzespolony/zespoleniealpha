extends CharacterBody2D

@export var speed = 400
@export var baseStats: startingStats
@onready var stats = $Stats

func _ready() -> void:
	stats.initialize(baseStats)
func get_input():
	look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * stats.speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
