extends Node

var registered_defaults = {
	#file_path to data : [owner : node, variable name : string]
}

var registered_save_on_quit = {
	#file_path to data : [owner : node, variable name : string, is append : bool]
}

func register_default_data(
		an_owner : Node, a_variable_name : String, 
		a_path_to_data : String) -> bool:
	if(registered_defaults.has(a_path_to_data)):
		return false
	registered_defaults.merge({a_path_to_data : [an_owner, a_variable_name]})
	return true

func reset_game_data() -> void:
	for a_file_path in registered_defaults.keys():
		var an_owner = registered_defaults[a_file_path][0]
		var a_variable_name = registered_defaults[a_file_path][1]
		an_owner.set(a_variable_name, read_save_file(a_file_path))

func register_save_on_quit(
		an_owner : Node, a_variable_name : String, 
		a_path_to_data : String, is_append : bool) -> bool:
	if(registered_save_on_quit.has(a_path_to_data)):
		return false
	registered_save_on_quit.merge({a_path_to_data : [an_owner, a_variable_name, is_append]})
	return true

func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST):
		_on_pending_quit()

func _on_pending_quit() -> void:
	for a_file_path in registered_save_on_quit.keys():
		var an_owner = registered_save_on_quit[a_file_path][0]
		var a_variable_name = registered_save_on_quit[a_file_path][1]
		var is_append = registered_save_on_quit[a_file_path][2]
		var a_value = an_owner.get(a_variable_name)
		write_save_file(a_file_path, a_value, is_append)

func read_save_file(file_path : String) -> Dictionary:
	if(FileAccess.file_exists(file_path)):
		var my_save_file := FileAccess.open(file_path, FileAccess.READ)
		var my_save_file_text := my_save_file.get_as_text()
		if(my_save_file_text.is_empty()): return {}
		var my_save_file_dict := JSON.parse_string(my_save_file_text)
		if(my_save_file_dict): return my_save_file_dict
		else: return {}
	return {}

func write_save_file(file_path : String, data, append : bool = false) -> void:
	var my_save_file
	if(not append):
		my_save_file = FileAccess.open(file_path, FileAccess.WRITE)
		if not my_save_file:
			return
	else:
		my_save_file = FileAccess.open(file_path, FileAccess.READ_WRITE)
		if not my_save_file:
			return
		my_save_file.seek_end()
	if(data is Dictionary):
		data = JSON.stringify(data, "\t")
	my_save_file.store_string(data)
	my_save_file.close()

func clear_file(file_path : String) -> void:
	write_save_file(file_path, {})

func try_make_dir(a_dir_path : String) -> bool:
	if not DirAccess.dir_exists_absolute(a_dir_path):
		DirAccess.make_dir_absolute(a_dir_path)
		return true
	return false

func remove_all_files_at_dir(a_dir_path : String) -> void:
	for a_source_file in DirAccess.get_files_at(a_dir_path):
		DirAccess.remove_absolute(a_dir_path + a_source_file)

func delete_dir_recursive(a_dir_path : String) -> void:
	remove_all_files_at_dir(a_dir_path)
	for a_subdir in DirAccess.get_directories_at(a_dir_path).duplicate():
		var subdir_path = a_dir_path + "/" + a_subdir + "/"
		delete_dir_recursive(subdir_path)
	DirAccess.remove_absolute(a_dir_path)

func string_to_vector3(a_string : String) -> Vector3:
	a_string = a_string.substr(1, a_string.length() - 2)
	var str_arr = a_string.split_floats(",")
	if str_arr.size() < 3:
		return Vector3.ZERO
	return Vector3(str_arr[0], str_arr[1], str_arr[2])

func string_to_vector2i(a_string : String) -> Vector2i:
	a_string = a_string.substr(1, a_string.length() - 2)
	var str_arr = a_string.split_floats(",")
	if str_arr.size() < 2:
		return Vector2i.ZERO
	return Vector2i(int(str_arr[0]), int(str_arr[1]))