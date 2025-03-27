extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var settings: bool = false
var Matchsettings: bool = false

@export var GAME_SCENE: PackedScene

func _ready() -> void:
	GameManager.paused = false
	GameManager.host_mode = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_host_pressed() -> void:
	_on_click()
	$Match_Settings.show()
	$Menu.hide()

func _on_join_pressed() -> void:
	_on_click()
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
	$Menu.show()
	$Match_Settings.hide()


func _on_host_game_button_pressed() -> void:
	GameManager.host_mode = true
	SceneLoad.Change_Scene(GAME_SCENE)


func _on_mouse_entered() -> void:
	pass
	#audio_player.set_parameter("GUI","Hover")
	#audio_player.play()

func _on_click() -> void:
	pass
	#audio_player.set_parameter("GUI","Click")
	#audio_player.play()
