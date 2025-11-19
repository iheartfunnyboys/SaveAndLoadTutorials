extends Control
const EMPTY_CURSOR = preload("uid://iwiyddvgot8d")

const PIXEL_HAND_GRAB = preload("uid://72qs5cwk5w4j")
const PIXEL_HAND_OPEN = preload("uid://cfi0878bgxwk8")
const CURSOR_HAND_POINT = preload("uid://cp3r1aljv362k")

const game_data_path := "user://my_data.json"
const harvest_count_key := "fruits_harvested"

var fruits_harvested : int = 0 :
	set(value):
		fruits_harvested = value
		if fruits_harvested > 0:
			if OS.get_name() == "Web":
				call_deferred("_store_score_data")
		if is_inside_tree():
			%FruitCountLbl.set_new_count(fruits_harvested)

func _ready() -> void:
	_read_score_data()
	tree_exiting.connect(_store_score_data)
	DisplayServer.cursor_set_custom_image(EMPTY_CURSOR)
	_set_cursor(PIXEL_HAND_OPEN)
	for a_child in get_children():
		if a_child.has_signal("fruit_harvested"):
			a_child.fruit_harvested.connect(_on_fruit_harvested)
		if a_child.has_signal("grab_fruit"):
			a_child.grab_fruit.connect(_grab_animation)

func _read_score_data() -> void:
	var data = IH_SaveLoad.read_save_file(game_data_path)
	if data.has(harvest_count_key):
		fruits_harvested = int(data[harvest_count_key])

func _store_score_data() -> void:
	var data = {}
	data.merge({harvest_count_key : fruits_harvested})
	IH_SaveLoad.write_save_file(game_data_path, data)

func _on_fruit_harvested() -> void:
	fruits_harvested += 1

func _grab_animation() -> void:
	_set_cursor(PIXEL_HAND_GRAB)
	await get_tree().create_timer(0.2).timeout
	_set_cursor(PIXEL_HAND_OPEN)

func _set_cursor(an_image, a_scale = Vector2(7, 7)) -> void:
	%CustomCursor.texture = an_image
	%CustomCursor.scale = a_scale

func _on_audio_control_panel_visibility_changed() -> void:
	if $AudioControlPanel.visible:
		_set_cursor(CURSOR_HAND_POINT)
	else:
		_set_cursor(PIXEL_HAND_OPEN)

func _on_open_audio_control_panel_btn_mouse_entered() -> void:
	_set_cursor(CURSOR_HAND_POINT)

func _on_open_audio_control_panel_btn_mouse_exited() -> void:
	_on_audio_control_panel_visibility_changed()
