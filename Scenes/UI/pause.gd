extends Control

func _ready() -> void:
	self.hide()

func _on_resume_button_pressed() -> void:
	unpause()


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Main Menu.tscn")


func _on_quit_windows_button_pressed() -> void:
	get_tree().quit()

func unpause():
	GameManager.mouseCap = true
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	GameManager.mouseCap = false
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
