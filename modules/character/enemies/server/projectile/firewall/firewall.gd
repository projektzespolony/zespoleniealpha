extends Area2D

@export var damage: int = 0
@export var speed: float = 300.0


func _physics_process(delta: float) -> void:
	position += transform.y * speed * delta


func _on_body_entered(body: Node2D) -> void:
	print("BULLET: Hit ", body, " dealing ", damage, " damage")
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if body != Player:
		queue_free()
