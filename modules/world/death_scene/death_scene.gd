extends CanvasLayer

var pics = []

@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	var path = "res://assets/ui/death_screens/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				break
			elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
				var pic = ResourceLoader.load(path + "/" + file_name)
				if pic:
					print(pic)
					pics.append(pic)
		dir.list_dir_end()

		if pics.size() > 1:
			var texture_id: int = randi() % pics.size()
			var chosen_texture: Texture = pics[texture_id]
			texture_rect.texture = chosen_texture


func _on_restart_button_up() -> void:
	Player.position = Vector2(0, 0)
	get_tree().change_scene_to_file("res://modules/world/game_scene/game_scene.tscn")


func _on_quit_button_up() -> void:
	get_tree().quit()
