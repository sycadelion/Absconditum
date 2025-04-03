extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var ui_audio: AkEvent2D = $UiAudio

var settings: bool = false
var Matchsettings: bool = false

@export var GAME_SCENE: PackedScene

func _ready() -> void:
	GameManager.paused = false
	GameManager.host_mode = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if GameManager.emptyConfig:
		GameManager.fire_prompt("Your Settings Have Been Reset",self)
		
func _on_host_pressed() -> void:
	_on_click()
	if GameManager.UserName == "":
		GameManager.fire_prompt("Please enter a user name first under user settings",self)
	else:
		SceneLoad.Load_Component(SceneLoad.Server_info)
		$Match_Settings.show()
		$Menu.hide()

func _on_join_pressed() -> void:
	_on_click()
	if GameManager.UserName == "":
		GameManager.fire_prompt("Please enter a user name first under user settings",self)
	else:
		SceneLoad.Change_Scene(GAME_SCENE)


func _on_quit_pressed() -> void:
	_on_click()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_settings_pressed() -> void:
	_on_click()
	$Settings.show()
	$Menu.hide()
	$GameTitle.hide()
	
func _on_settings_back_button_pressed() -> void:
	_on_click()
	$Menu.show()
	$GameTitle.show()
	$Settings.hide()

func _on_match_back_button_pressed() -> void:
	_on_click()
	SceneLoad.Remove_Component(SceneLoad.Server_info)
	$Menu.show()
	$Match_Settings.hide()


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
	$Music.post_event()
