class_name spawner extends Area2D
@export var spawnList: SpawnList
@export var numberOfSpawns: int

func _on_body_entered(body: Node2D) -> void:
	var collider = $SpawnCollider.get_shape()
	var rng = RandomNumberGenerator.new()
	while numberOfSpawns > 0:
		rng.randomize()
		var index : int = rng.randi_range(0, len(spawnList.list)-1)
		var entity = spawnList.list[index].instantiate()
		var x_boundary = collider.size.x * self.transform.x[0]
		var y_boundary = collider.size.y *self.transform.y[0]
		entity.position = self.position + Vector2(rng.randf_range(-x_boundary,x_boundary),rng.randf_range(-y_boundary,y_boundary))
		get_parent().add_child(entity)
		numberOfSpawns -= 1			
	queue_free()
