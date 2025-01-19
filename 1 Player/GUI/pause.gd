extends Control

var id = 0
var settings_open: bool = false
var Menu_scene: String = "res://7 GUI/Menus/Main Menu.tscn"
@onready var roomcode: Control = $Roomcode
@onready var roomcode_label: Label = $Roomcode/PanelContainer/VBoxContainer/roomcode_label
@onready var code: TextEdit = $Roomcode/PanelContainer/VBoxContainer/Code


func _ready() -> void:
	self.hide()

func _on_resume_button_pressed() -> void:
	unpause()


func _on_quit_button_pressed() -> void:
	multiplayer.peer_disconnected.emit(id)
	SceneLoad.Remove_Component(SceneLoad.online_connection)
	SceneLoad.Change_Scene(SceneLoad.Default_Scene)


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
	print(str(id))
	GameManager.mouseCap = false
	settings_open = false
	GameManager.paused = true
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if GameManager.host_mode:
		roomcode.show()
		roomcode_label.text = "Roomcode: "
		code.text = RoomGen.IPtoCode(OnlineMang.Host_IP)

func _on_setting_button_pressed() -> void:
	$Settings_menu.show()
	$Buttons.hide()

func _on_settings_back_button_pressed() -> void:
	$Buttons.show()
	$Settings_menu.hide()
