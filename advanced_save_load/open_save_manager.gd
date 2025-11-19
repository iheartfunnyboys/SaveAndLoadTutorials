extends EnhancedButton

const SAVE_MANAGER = preload("res://2_advanced_saving/save_manager.tscn")

func _ready() -> void:
	super._ready()
	await owner.ready
	_open_save_manager()

func _on_pressed() -> void:
	super._on_pressed()
	_open_save_manager()

func _open_save_manager() -> void:
	SavePath.pre_save_path_changed.emit()
	var save_manager = SAVE_MANAGER.instantiate()
	owner.add_child(save_manager)
	save_manager.show_animated()

func _on_hovered() -> void:
	super._on_hovered()
