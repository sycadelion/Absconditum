extends Control

var settings_open: bool = false


func _ready() -> void:
	self.hide()

func _on_resume_button_pressed() -> void:
	unpause()


func _on_quit_button_pressed() -> void:
	SceneLoad.Change_Scene(SceneLoad.Default_Scene)


func _on_quit_windows_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func unpause():
	GameManager.mouseCap = true
	GameManager.paused = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func pause():
	GameManager.mouseCap = false
	settings_open = false
	GameManager.paused = true
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_setting_button_pressed() -> void:
	$Settings_menu.show()
	$Buttons.hide()

func _on_settings_back_button_pressed() -> void:
	$Buttons.show()
	$Settings_menu.hide()
