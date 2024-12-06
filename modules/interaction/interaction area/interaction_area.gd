extends Area2D
class_name InteractionArea

@export var interaction_name: String = "interact"

#Callable przechowuje funkcje, nadpisywane przy inheritance
var interact: Callable = func(): print("ITEM: Interacted")


func _on_body_entered(body: Node2D) -> void:
	print("INTERACTION_AREA: ", body, " walked into me")
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	print("INTERACTION_AREA: ", body, " walked out")
	InteractionManager.unregister_area(self)
