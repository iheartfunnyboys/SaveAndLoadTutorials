extends EnhancedPanel

const SAVE_DATA_PANEL = preload("res://2_advanced_saving/save_data_panel.tscn")

func _ready() -> void:
	%NewSaveButton.pressed.connect(_on_new_save_pressed)
	if not IH_SaveLoad.try_make_dir(SavePath.leading_save_string):
		var file_set = {}
		for a_dir in DirAccess.get_directories_at(SavePath.leading_save_string):
			var last_date = FileAccess.get_modified_time(SavePath.leading_save_string \
				 + "/" + a_dir + "/" + SavePath.master_save)
			while file_set.has(last_date):
				last_date += 1
			file_set.merge({last_date : a_dir})
		var files_sorted = file_set.keys()
		files_sorted.sort()
		files_sorted.reverse()
		for a_dir in files_sorted:
			_make_save_button(file_set[a_dir])

func _make_save_button(a_file_path) -> void:
	var panel = SAVE_DATA_PANEL.instantiate()
	%SaveDataList.add_child(panel)
	panel.owner = self
	panel.set_directory_path(a_file_path)
	panel.save_selected.connect(_close_save_manager)

func _on_new_save_pressed() -> void:
	var new_file_name = %NewSaveName.text
	if new_file_name == "":
		return
	DirAccess.make_dir_absolute(SavePath.leading_save_string + "/" + new_file_name)
	SavePath.save_folder_name = "/" + new_file_name + "/"
	_close_save_manager()

func get_valid_save_name(input_save_name : String) -> String:
	if input_save_name.is_empty():
		input_save_name = "my_save"
	else:
		input_save_name = input_save_name.validate_filename()
	while DirAccess.dir_exists_absolute(SavePath.leading_save_string + "/" + input_save_name):
		var last_char = input_save_name.substr(input_save_name.length()-1)
		if last_char.is_valid_int():
			var number = int(last_char)
			if not number == 9:
				input_save_name = input_save_name.replace(last_char, str(number + 1))
			else:
				input_save_name += "1"
		else:
			input_save_name += "1"
	return input_save_name

func _close_save_manager() -> void:
	await hide_animated()
	queue_free()
