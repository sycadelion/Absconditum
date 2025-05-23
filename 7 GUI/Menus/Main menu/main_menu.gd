extends Control

@onready var ui_audio: AkEvent2D = %UiAudio
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var multiplayer_menu: PanelContainer = %MultiplayerMenu
@onready var MultiBack: Button = $CanvasLayer/MultiplayerMenu/CenterContainer/MarginContainer/VSplitContainer/VBoxContainer/Back

var settings: bool = false
var Matchsettings: bool = false

@export var GAME_SCENE: PackedScene
@export var SOLO_GAME_SCENE: PackedScene

func _ready() -> void:
	GameManager.paused = false
	GameManager.host_mode = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if SettingsManager.emptyConfig:
		GameManager.fire_prompt("Your Settings Have Been Reset",canvas_layer)
		
func _on_host_pressed() -> void:
	_on_click()
	if SettingsManager.UserName == "":
		GameManager.fire_prompt("Please enter a user name first under user settings",canvas_layer)
	else:
		SceneLoad.Load_Component(SceneLoad.Server_info)
		%Match_Settings.show()
		multiplayer_menu.hide()

func _on_join_pressed() -> void:
	_on_click()
	if SettingsManager.UserName == "":
		GameManager.fire_prompt("Please enter a user name first under user settings",canvas_layer)
	else:
		SceneLoad.Change_Scene(GAME_SCENE)


func _on_quit_pressed() -> void:
	_on_click()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_settings_pressed() -> void:
	_on_click()
	%Settings.show()
	%Menu.hide()
	%GameTitle.hide()
	
func _on_settings_back_button_pressed() -> void:
	_on_click()
	%Menu.show()
	%GameTitle.show()
	%Settings.hide()

func _on_match_back_button_pressed() -> void:
	_on_click()
	SceneLoad.Remove_Component(SceneLoad.Server_info)
	%Menu.show()
	%Match_Settings.hide()


func _on_host_game_button_pressed() -> void:
	_on_click()
	GameManager.host_mode = true
	SceneLoad.Change_Scene(GAME_SCENE)


func _on_mouse_entered() -> void:
	Wwise.set_switch("Menus","Hover",ui_audio)
	ui_audio.post_event()

func _on_click() -> void:
	Wwise.set_switch("Menus","Click",ui_audio)
	ui_audio.post_event()


func _on_music_music_sync_exit(_data: Dictionary) -> void:
	%Music.post_event()


func _on_MultiBack_pressed() -> void:
	multiplayer_menu.hide()
	%Menu.show()


func _on_multiplayer_pressed() -> void:
	%Menu.hide()
	multiplayer_menu.show()


func _on_solo_pressed() -> void:
	SceneLoad.Change_Scene(SOLO_GAME_SCENE)
