extends Node2D

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	#nowa funkcja dla interackji parametry: (kto ma funkcje, 99% self, nazwa funkcji)


func _on_interact():
	print("ITEM: Picked Up")
