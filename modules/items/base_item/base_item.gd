extends Node2D

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	# new function for interaction
	# parameters: who has the function, 99% self, function name


func _on_interact():
	print("ITEM: Picked Up")
