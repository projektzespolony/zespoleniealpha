extends Control

@onready var main: Node = $".."


func _on_resume_button_button_up() -> void:
	main.pause_menu()


func _on_exit_button_button_up() -> void:
	get_tree().quit()


func _on_main_menu_button_button_up() -> void:
	get_tree().change_scene_to_file("res://modules/world/main_menu_scene/main_menu.tscn")
