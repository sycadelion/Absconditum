extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var settings: bool = false
var Matchsettings: bool = false

const GAME_SCENE = "res://Scenes/lobby.tscn"

func _ready() -> void:
	pass

func _on_host_pressed() -> void:
	$Match_Settings.show()
	$Menu.hide()

func _on_join_pressed() -> void:
	get_tree().call_deferred(&"change_scene_to_packed",preload(GAME_SCENE))


func _on_quit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_settings_pressed() -> void:
	$Settings.show()
	$Menu.hide()
	
func _on_settings_back_button_pressed() -> void:
	$Menu.show()
	$Settings.hide()

func _on_match_back_button_pressed() -> void:
	$Menu.show()
	$Match_Settings.hide()


func _on_host_game_button_pressed() -> void:
	GameManager.host_mode = true
	get_tree().call_deferred(&"change_scene_to_packed",preload(GAME_SCENE))
