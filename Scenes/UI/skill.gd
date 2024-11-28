extends Control

@onready var pBar: ProgressBar = $PanelContainer/MarginContainer/ProgressBar

@export var maxValue = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if pBar.value >= 1:
		pBar.value -=  1

func used_skill():
	if pBar.value <= 0:
		pBar.value = maxValue
		return true
	else:
		return false
