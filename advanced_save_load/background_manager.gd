extends Control

enum ToD {DAY, NIGHT}
var my_tod : ToD = ToD.DAY:
	set(value):
		my_tod = value
		match(value):
			ToD.DAY:
				$BackgroundImageDay.visible = true
				$BackgroundImageNight.visible = false
			ToD.NIGHT:
				$BackgroundImageDay.visible = false
				$BackgroundImageNight.visible = true

func _ready() -> void:
	$ToDBtn.pressed.connect(_toggle_tod)

func get_save_data() -> Dictionary:
	var save_data : Dictionary
	save_data.merge({"ToD" : my_tod})
	return save_data

func load_save_data(save_data : Dictionary) -> void:
	if save_data.has("ToD"):
		my_tod = ToD.values()[int(save_data["ToD"])]
	else:
		my_tod = ToD.DAY

func _toggle_tod() -> void:
	match my_tod:
		ToD.DAY:
			my_tod = ToD.NIGHT
		ToD.NIGHT:
			my_tod = ToD.DAY
