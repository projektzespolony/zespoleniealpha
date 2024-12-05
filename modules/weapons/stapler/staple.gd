extends Area2D

@export var damage: int = 0
@export var speed: float = 2000.0
@export var decay_factor: float = 0.95


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	speed *= decay_factor
	if speed <= 50.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("BULLET: Hit ", body, " dealing ", damage, " damage")
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
