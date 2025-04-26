extends Control

@export var Label_Text: String
@export var audio_bus_index: String

@onready var vol_slider: HSlider = %VolSlider
@onready var audio_bus_label: Label = %"Audio Bus Label"
@onready var bus_edit: LineEdit = %BusEdit


var pauseValues = false

func _ready() -> void:
	if bus_edit:
		audio_bus_label.text = Label_Text + ": "
		bus_edit.text = str(GameManager.get(audio_bus_index))
		vol_slider.value = GameManager.get(audio_bus_index)

func _process(delta: float) -> void:
	if !pauseValues:
		vol_slider.value = GameManager.get(audio_bus_index)
		bus_edit.text = str(vol_slider.value)

func _on_drag_started() -> void:
	pauseValues = true

func _on_mouse_exited() -> void:
	release_focus()

func _on_vol_slider_drag_ended(value_changed: bool) -> void:
	Wwise.set_rtpc_value(audio_bus_index,vol_slider.value,null)
	GameManager.set(audio_bus_index, vol_slider.value)
	pauseValues = false

func _on_bus_edit_focus_entered() -> void:
	pauseValues = true
	
func _on_bus_edit_focus_exited() -> void:
	pauseValues = false

func _on_bus_edit_text_changed(new_text: String) -> void:
	var new_value =  int(new_text)
	Wwise.set_rtpc_value(audio_bus_index,new_value,null)
	GameManager.set(audio_bus_index,new_value)
	vol_slider.value = new_value
