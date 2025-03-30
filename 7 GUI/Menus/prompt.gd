extends Control

@export var Prompt_Text: String
@onready var prompt_label: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/prompt_Label

func _ready() -> void:
	prompt_label.text = Prompt_Text

func _on_accept_button_pressed() -> void:
	self.queue_free()

func set_data(promptText:String):
	prompt_label.text = promptText
