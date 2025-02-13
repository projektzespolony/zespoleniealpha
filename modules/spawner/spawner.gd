extends Node2D
@export var enemy_spawn_locations: TileMapLayer
@export var item_spawn_locations: TileMapLayer
@export var boss_arena: TileMapLayer
@export var enemy_list: SpawnList
@export var item_list: SpawnList
@export var enemy_limit: int
@export var item_limit: int
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	spawn_all_entities(0.5, 1.5, enemy_limit, enemy_spawn_locations, enemy_list, false, false)
	spawn_all_entities(3, 5, item_limit, item_spawn_locations, item_list, true, true)


func spawn_all_entities(
	lower_time_bound: float,
	upper_timer_bound: float,
	limit: int,
	spawn_location: TileMapLayer,
	spawn_list: SpawnList,
	pop_from_list: bool,
	remove_spawn_tile: bool
) -> void:
	for i in range(limit):
		await get_tree().create_timer(rng.randf_range(lower_time_bound, upper_timer_bound)).timeout
		spawn_entity(spawn_location, spawn_list, pop_from_list, remove_spawn_tile)


func spawn_entity(
	spawn_location: TileMapLayer,
	spawn_list: SpawnList,
	pop_from_list: bool,
	remove_spawn_tile: bool
) -> void:
	var possible_tiles: Array[Vector2i] = spawn_location.get_used_cells()
	var tile_index: int = rng.randi_range(0, len(possible_tiles) - 1)
	var entity_index: int = rng.randi_range(0, len(spawn_list.list) - 1)
	var entity: Node = spawn_list.list[entity_index].instantiate()
	entity.position = possible_tiles[tile_index] * spawn_location.tile_set.tile_size
	if pop_from_list:
		spawn_list.list.pop_at(entity_index)
	if remove_spawn_tile:
		item_spawn_locations.erase_cell(possible_tiles[tile_index])
	get_tree().current_scene.call_deferred("add_child", entity)


func check_end_of_stage_staus() -> void:
	enemy_limit -= 1
	if len(get_tree().get_nodes_in_group("Enemies")) == 0 and enemy_limit == 0:
		get_tree().call_group("BossArena", "start_boss_fight")
