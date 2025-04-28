extends Control

@export var MinV: int = 0
@export var MaxV: int = 10

@onready var mouse_sens: Label = %MouseSens
@onready var sens_text: LineEdit = %sensText
@onready var mouse_sens_slider: HSlider = %"MouseSens Slider"

var pauseValues = false

func _ready() -> void:
	if SettingsManager:
		sens_text.text = str(SettingsManager.MouseSensitivity)

func _process(_delta: float) -> void:
	if !pauseValues:
		sens_text.text = str(SettingsManager.MouseSensitivity)
		mouse_sens_slider.value = SettingsManager.MouseSensitivity

func _on_drag_started() -> void:
	pauseValues = true

func _on_vol_slider_drag_ended(_value_changed: bool) -> void:
	SettingsManager.MouseSensitivity = mouse_sens_slider.value
	pauseValues = false

func _on_mouse_exited() -> void:
	release_focus()

func _on_bus_edit_focus_entered() -> void:
	pauseValues = true

func _on_bus_edit_focus_exited() -> void:
	pauseValues = false

func _on_bus_edit_text_changed(new_text: String) -> void:
	var new_value =  float(new_text)
	SettingsManager.MouseSensitivity = new_value
	mouse_sens_slider.value = new_value
