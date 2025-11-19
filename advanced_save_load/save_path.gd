#autoload SavePath
extends Node

const harvest_count_key := "fruits_harvested"

const leading_save_string = "user://game_saves"
const master_save = "game_data.json"
var save_folder_name : String : 
	set(value):
		save_folder_name = value
		source_image_dir = leading_save_string + save_folder_name + source_image_path
		master_save_path = leading_save_string + save_folder_name + master_save
		save_path_changed.emit()
const source_image_path : String = "temp_source_images/"
var source_image_dir : String
var master_save_path : String

signal save_path_changed()
@warning_ignore("unused_signal") signal pre_save_path_changed()
