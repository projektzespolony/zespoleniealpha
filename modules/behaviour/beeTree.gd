extends BeehaveTree


func _ready() -> void:
	# ensure _ready() has been finished everywhere else
	await get_tree().root.ready
