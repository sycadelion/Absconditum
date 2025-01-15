extends HSlider

@export var settingsVar: String
@export var minV = 0
@export var maxV = 100
@export var is_audio: bool
@export var bus_index: int
var setValue: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_audio:
		setValue = GameManager.get(settingsVar)
	elif is_audio:
		setValue = 100*GameManager.fmodbuses[bus_index].volume
	value = setValue
	min_value = minV
	max_value = maxV

func _on_value_changed(valueVar: float) -> void:
	if not is_audio:
		GameManager.set(settingsVar, valueVar)
	else:
		GameManager.fmodbuses[bus_index].volume = value / 100
