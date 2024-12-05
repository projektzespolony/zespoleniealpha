extends Area2D
class_name InteractionArea

@export var interaction_name: String = "interact"

var interact: Callable = func(): #Callable przechowuje funkcje, nadpisywane przy inheritance
	pass


func _on_body_entered(body: Node2D) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)
