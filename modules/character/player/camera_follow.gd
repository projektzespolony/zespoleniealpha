class_name CameraFollow extends Camera2D

const OFFSET: int = 5
@export var tile_map: TileMapLayer
@export var boss_arena: BossArena
@onready var tile_map_boss_arena: TileMapLayer = boss_arena.get_child(0)


func _ready() -> void:
	var map_rect = tile_map.get_used_rect()
	var quadrant_size = tile_map.rendering_quadrant_size
	var world_size = map_rect.size * quadrant_size
	self.limit_right = world_size.x + (map_rect.position.x - OFFSET) * quadrant_size
	self.limit_bottom = world_size.y + (map_rect.position.y - OFFSET) * quadrant_size


func _process(_delta: float) -> void:
	self.position = Player.position


func change_camera_to_boss_room():
	var position_in_world: Vector2 = boss_arena.position
	var map_rect_boss: Rect2i = tile_map_boss_arena.get_used_rect()
	var quadrant_size_boss: int = tile_map_boss_arena.rendering_quadrant_size
	self.limit_left = position_in_world.x - abs(map_rect_boss.position.x * quadrant_size_boss)
	self.limit_top = position_in_world.y - abs(map_rect_boss.position.y * quadrant_size_boss)
	self.limit_right = (
		position_in_world.x
		- abs(map_rect_boss.position.x * quadrant_size_boss)
		+ map_rect_boss.size.x * quadrant_size_boss
	)
	self.limit_bottom = (
		position_in_world.y
		- abs(map_rect_boss.position.y * quadrant_size_boss)
		+ map_rect_boss.size.y * quadrant_size_boss
	)
