extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	# new function for interaction
	# parameters: who has the function, 99% self, function name


func _on_interact() -> void:
	print("ITEM: Picked Up")
