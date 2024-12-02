extends Control

var id = 0
@onready var settings_menu: Control = $Settings_menu
@onready var buttons: PanelContainer = $Buttons

func _ready() -> void:
	self.hide()

func _on_resume_button_pressed() -> void:
	unpause()


func _on_quit_button_pressed() -> void:
	if GameManager.host_mode:
		multiplayer.multiplayer_peer.close()
	else:
		multiplayer.multiplayer_peer = null
		Lobby.players = {}
	get_tree().change_scene_to_file("res://Scenes/UI/Main Menu.tscn")


func _on_quit_windows_button_pressed() -> void:
	get_tree().quit()

func unpause():
	GameManager.mouseCap = true
	GameManager.paused = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause(owner_id):
	settings_menu.hide()
	buttons.show()
	id = owner_id
	GameManager.mouseCap = false
	GameManager.paused = true
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_setting_button_pressed() -> void:
	settings_menu.show()
	buttons.hide()

func _on_button_pressed() -> void:
	settings_menu.hide()
	buttons.show()
