extends HSlider

@export var settingsVar: String
@export var min = 0
@export var max = 100
@export var is_audio: bool
@export var bus_name: String
var bus_index: int
var setValue: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_audio:
		setValue = GameManager.get(settingsVar)
	elif is_audio:
		bus_index = AudioServer.get_bus_index(bus_name)
		setValue = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	value = setValue
	min_value = min
	max_value = max

func _on_value_changed(value: float) -> void:
	if not is_audio:
		GameManager.set(settingsVar, value)
	else:
		AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
