extends Control

@onready var your_ip: Label = $icup/MarginContainer/HBoxContainer/YourIp
@onready var ip_blur: ColorRect = $Ip_Blur


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
