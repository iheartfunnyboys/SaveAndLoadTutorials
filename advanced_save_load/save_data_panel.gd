extends PanelContainer

signal save_selected()

func _ready() -> void:
	%Button.pressed.connect(_on_save_pressed)
	%RenameSave.pressed.connect(_on_rename_save_pressed)
	%CopySave.pressed.connect(_on_copy_save_pressed)
	%DeleteSave.pressed.connect(_on_delete_save_pressed)

func set_directory_path(a_string : String) -> void:
	%SaveName.text = a_string
	var time_modified = FileAccess.get_modified_time(SavePath.leading_save_string + "/" + a_string + "/" + SavePath.master_save)
	if not time_modified == 0:
		%SaveDate.text = Time.get_datetime_string_from_unix_time(time_modified, true)
	else:
		%SaveDate.text = ""
	var general_data = IH_SaveLoad.read_save_file(SavePath.leading_save_string + "/" + a_string + "/" + SavePath.master_save)
	if general_data.has(SavePath.harvest_count_key):
		%GrapeCount.text = str(int(general_data[SavePath.harvest_count_key]))
	else:
		%GrapeCount.text = "0"

func _delete_save() -> void:
	IH_SaveLoad.delete_dir_recursive(SavePath.leading_save_string + "/" + %SaveName.text + "/")

func _copy_save(a_new_dir_name : String) -> void:
	var old_path = SavePath.leading_save_string + "/" + %SaveName.text
	var new_path = SavePath.leading_save_string + "/" + a_new_dir_name
	DirAccess.make_dir_recursive_absolute(new_path)
	for a_file in DirAccess.get_files_at(old_path):
		DirAccess.copy_absolute(old_path + "/" + a_file, new_path + "/" + a_file)
	var panel = owner.SAVE_DATA_PANEL.instantiate()
	add_sibling(panel)
	panel.owner = owner
	get_parent().move_child(panel, 0)
	panel.set_directory_path(a_new_dir_name)

func _rename_save(a_new_dir_name : String) -> void:
	_copy_save(a_new_dir_name)
	_delete_save()
	queue_free()

func _on_save_pressed() -> void:
	SavePath.save_folder_name = "/" + %SaveName.text + "/"
	save_selected.emit()

func _on_copy_save_pressed() -> void:
	var save_name = %RenameText.text
	if not save_name == "":
		%RenameText.text = ""
		_copy_save(save_name)

func _on_delete_save_pressed() -> void:
	_delete_save()
	queue_free()

func _on_rename_save_pressed() -> void:
	var save_name = %RenameText.text
	if not save_name == "":
		if not save_name == %SaveName.text:
			%RenameText.text = ""
			_rename_save(save_name)
