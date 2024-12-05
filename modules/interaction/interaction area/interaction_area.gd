extends Area2D
class_name InteractionArea

@export var interaction_name: String = "interact"

var interact: Callable = func(): #Callable przechowuje funkcje, nadpisywane przy inheritance
	print("ITEM: Interacted")


func _on_body_entered(body: Node2D) -> void:
	print("INTERACTION_AREA: Something walked into me")
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	print("INTERACTION_AREA: Something walked out")
	InteractionManager.unregister_area(self)
