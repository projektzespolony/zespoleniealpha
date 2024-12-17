class_name InteractionArea
extends Area2D

@export var interaction_name: String = "interact"

# Callable stores functions, overridden during inheritance
var interact: Callable = func() -> void: pass

var show_details: Callable = func() -> void: pass


func _on_body_entered(body: Node2D) -> void:
	print("INTERACTION_AREA: ", body, " walked into me")
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	print("INTERACTION_AREA: ", body, " walked out")
	InteractionManager.unregister_area(self)
