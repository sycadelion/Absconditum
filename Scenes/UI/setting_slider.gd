extends HSlider

@export var settingsVar: String
@export var min = 0
@export var max = 100
var setValue: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	min_value = min
	max_value = max
	setValue = GameManager.get(settingsVar)
	value = setValue

func _on_value_changed(value: float) -> void:
	GameManager.set(settingsVar, value)
