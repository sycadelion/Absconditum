extends Control

@onready var your_ip: Label = $icup/MarginContainer/HBoxContainer/YourIp
@onready var ip_blur: ColorRect = $Ip_Blur
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var settings: bool = false

var hide = 2

func _ready() -> void:
	if OS.get_name() == "Windows":
		your_ip.text = str(IP.get_local_addresses()[3])

func _on_play_pressed() -> void:
	GameManager.host_mode = true
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")


func _on_join_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_reveal_ip_pressed() -> void:
	ip_blur.visible = not ip_blur.visible


func _on_settings_pressed() -> void:
	if settings:
		anim_player.play_backwards("Settings_open")
		settings = false
	else:
		anim_player.play("Settings_open")
		settings = true
