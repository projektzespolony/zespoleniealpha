class_name spawner extends Area2D
@export var spawnList: SpawnList
@export var numberOfSpawns: int
const OFFSET = 100
var rng : RandomNumberGenerator = RandomNumberGenerator.new() 

func _on_body_entered(_body: Node2D) -> void:
	await get_tree().create_timer(0.2).timeout
	var collider: Shape2D = $SpawnCollider.get_shape()
	while numberOfSpawns > 0:
		rng.randomize()
		var index : int = rng.randi_range(0, len(spawnList.list)-1)
		var entity : Node2D = spawnList.list[index].instantiate()
		var x_boundary : float = collider.size.x/2 
		var y_boundary : float= collider.size.y/2 
		entity.position = self.position + Vector2(rng.randf_range(-x_boundary + OFFSET,x_boundary - OFFSET),rng.randf_range(-y_boundary + OFFSET,y_boundary - OFFSET))
		get_tree().current_scene.call_deferred("add_child", entity)
		numberOfSpawns -= 1			
	queue_free()
