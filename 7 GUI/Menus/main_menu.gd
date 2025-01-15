extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: FmodEventEmitter2D = $FmodEventEmitter2D

var settings: bool = false
var Matchsettings: bool = false

const GAME_SCENE = "res://6 Online/lobby.tscn"

func _ready() -> void:
	GameManager.paused = false
	GameManager.host_mode = false

func _on_host_pressed() -> void:
	_on_click()
	$Match_Settings.show()
	$Menu.hide()

func _on_join_pressed() -> void:
	_on_click()
	get_tree().call_deferred(&"change_scene_to_packed",preload(GAME_SCENE))


func _on_quit_pressed() -> void:
	_on_click()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_settings_pressed() -> void:
	_on_click()
	$Settings.show()
	$Menu.hide()
	
func _on_settings_back_button_pressed() -> void:
	_on_click()
	$Menu.show()
	$Settings.hide()

func _on_match_back_button_pressed() -> void:
	_on_click()
	$Menu.show()
	$Match_Settings.hide()


func _on_host_game_button_pressed() -> void:
	GameManager.host_mode = true
	get_tree().call_deferred(&"change_scene_to_packed",preload(GAME_SCENE))


func _on_mouse_entered() -> void:
	audio_player.set_parameter("GUI","Hover")
	audio_player.play()

func _on_click() -> void:
	audio_player.set_parameter("GUI","Click")
	audio_player.play()
