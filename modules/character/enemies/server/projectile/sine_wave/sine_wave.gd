extends Area2D

@export var damage: int = 0
@export var speed: float = 500.0
var counter: float
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var offset: float = rng.randf_range(0, PI)


func _physics_process(delta: float) -> void:
	counter += delta
	position += transform.y * sin(6 * counter + offset) * 250 * delta
	position += transform.x * speed / 3 * delta


func _on_body_entered(body: Node2D) -> void:
	print("BULLET: Hit ", body, " dealing ", damage, " damage")
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if body != Player:
		queue_free()
