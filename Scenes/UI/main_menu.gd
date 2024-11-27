extends Control

@onready var your_ip: Label = $icup/MarginContainer/HBoxContainer/YourIp
@onready var color_rect: ColorRect = $ColorRect

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
	var shaderMat:ShaderMaterial = color_rect.material
	hide = -hide
	shaderMat.set_shader_parameter("lod",hide)
