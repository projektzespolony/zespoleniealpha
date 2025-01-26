extends Node2D
@export var enemy_spawn_locations: TileMapLayer
@export var item_spawn_locations: TileMapLayer
@export var enemy_list: SpawnList
@export var item_list: SpawnList
@export var enemy_limit: int
@export var item_limit: int
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	spawn_enemy()
	spawn_item()


func spawn_enemy() -> void:
	await get_tree().create_timer(rng.randf_range(0.5, 1.5)).timeout
	if len(get_tree().get_nodes_in_group("Enemies")) == 0 and enemy_limit == 0:
		pass  #Spawning Boss door: TODO

	if enemy_limit <= 0:
		return

	var possible_tiles: Array[Vector2i] = enemy_spawn_locations.get_used_cells()
	rng.randomize()
	var tile_index: int = rng.randi_range(0, len(possible_tiles) - 1)
	var enemy_index: int = rng.randi_range(0, len(enemy_list.list) - 1)
	var entity: Node = enemy_list.list[enemy_index].instantiate()
	entity.add_to_group("Enemies")
	entity.position = possible_tiles[tile_index] * enemy_spawn_locations.tile_set.tile_size
	get_tree().current_scene.call_deferred("add_child", entity)
	enemy_limit -= 1
	spawn_enemy()


func spawn_item() -> void:
	await get_tree().create_timer(rng.randf_range(3.0, 5.0)).timeout
	if item_limit <= 0:
		return
	var possible_tiles: Array[Vector2i] = item_spawn_locations.get_used_cells()
	var tile_index: int = rng.randi_range(0, len(possible_tiles) - 1)
	var item_index: int = rng.randi_range(0, len(item_list.list) - 1)
	var entity: Node = item_list.list[item_index].instantiate()
	entity.position = possible_tiles[tile_index] * item_spawn_locations.tile_set.tile_size
	item_list.list.pop_at(item_index)
	item_spawn_locations.erase_cell(possible_tiles[tile_index])
	get_tree().current_scene.call_deferred("add_child", entity)
	item_limit -= 1
	spawn_item()
