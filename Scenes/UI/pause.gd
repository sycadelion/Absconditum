extends Control

var id = 0
var settings_open: bool = false
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var roomcode: Control = $Roomcode
@onready var roomcode_label: Label = $Roomcode/PanelContainer/VBoxContainer/roomcode_label
@onready var code: TextEdit = $Roomcode/PanelContainer/VBoxContainer/Code


func _ready() -> void:
	self.hide()

func _on_resume_button_pressed() -> void:
	unpause()


func _on_quit_button_pressed() -> void:
	if GameManager.host_mode:
		multiplayer.multiplayer_peer.close()
		get_tree().change_scene_to_file("res://Scenes/UI/Main Menu.tscn")
	else:
		Lobby._on_server_disconnected()


func _on_quit_windows_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func unpause():
	GameManager.mouseCap = true
	GameManager.paused = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func pause(owner_id):
	id = owner_id
	GameManager.mouseCap = false
	settings_open = false
	GameManager.paused = true
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if GameManager.host_mode:
		roomcode.show()
		roomcode_label.text = "Roomcode: "
		code.text = RoomGen.IPtoCode(Lobby.ip)

func _on_setting_button_pressed() -> void:
	$Settings_menu.show()
	$Buttons.hide()

func _on_settings_back_button_pressed() -> void:
	$Buttons.show()
	$Settings_menu.hide()
