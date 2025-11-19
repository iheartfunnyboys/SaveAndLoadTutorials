@tool
extends EditorPlugin
class_name AddonUtility

var GLOBAL_PATH = ""
var GLOBAL_NAME = ""

func _enter_tree() -> void:
	add_autoload_singleton(GLOBAL_NAME, GLOBAL_PATH)

func _exit_tree() -> void:
	remove_autoload_singleton(GLOBAL_NAME)
