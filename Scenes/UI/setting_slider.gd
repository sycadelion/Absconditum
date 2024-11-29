extends HSlider

@export var settingsVar = 0
@export var min = 0
@export var max = 100
var setValue: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	min_value = min
	max_value = max
	if settingsVar == 0:
		setValue = GameManager.skill_Cooldown
		value = setValue
	elif settingsVar == 1:
		setValue= GameManager.skill1_radius
		value = setValue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_value_changed(value: float) -> void:
	if settingsVar == 0:
		GameManager.skill_Cooldown = value
	elif settingsVar == 1:
		GameManager.skill1_radius = value
