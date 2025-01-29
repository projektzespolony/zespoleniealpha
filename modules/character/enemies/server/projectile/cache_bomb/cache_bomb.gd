extends Area2D

@export var damage: int = 0
@export var speed: float = 500.0

var player_pos: Vector2 = Player.global_position

@onready var explosion_hitbox: Area2D = $ExplosionHitbox


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta * 0.99
	var distance_to_player: float = sqrt(
		(
			((self.global_position.x - player_pos.x) ** 2)
			+ ((self.global_position.y - player_pos.y) ** 2)
		)
	)
	print(distance_to_player)
	if distance_to_player <= 100:
		speed = 0
		await get_tree().create_timer(0.5).timeout
		explode()


func explode() -> void:
	explosion_hitbox.set_disabled(false)
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if !body.has_method("take_damage"):
		return
	var damage_to_deal: float = damage
	body.take_damage(damage_to_deal)
