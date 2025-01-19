class_name MultiplayerLobby extends Node

var level_scene: PackedScene = preload("res://5 Levels/Hub/hub.tscn")
@onready var level_container: Node = $Level
@onready var ip_line_edit: LineEdit = $Multiplayer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/IPLineEdit
@onready var lobby_ui: CanvasLayer = $Multiplayer
@onready var background_container: Control = $Background_container

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	SceneLoad.Load_Component(SceneLoad.online_connection)
	
	if GameManager.host_mode:
		_host()
	
func _host() -> void:
	background_container.hide()
	OnlineMang.Host.emit()
	hide_menu.rpc()
	change_level(level_scene)

func _on_connect_pressed() -> void:
	if ip_line_edit.text == GameManager.LOCAL_HOST:
		OnlineMang.Join.emit(ip_line_edit.text)
	else:
		OnlineMang.Join.emit(RoomGen.codeToIP(ip_line_edit.text))
	background_container.hide()


func _on_back_button_pressed() -> void:
	SceneLoad.Remove_Component(SceneLoad.online_connection)
	SceneLoad.Change_Scene(SceneLoad.Default_Scene)


func change_level(scene):
	for c in level_container.get_children():
		level_container.remove_child(c)
		c.queue_free()
	level_container.add_child(scene.instantiate())

func _on_connection_failed():
	$Multiplayer/ErrorPrompt.visible = true

func _on_connected_to_server():
	hide_menu.rpc()
	change_level(level_scene)

@rpc("any_peer", "call_local", "reliable")
func hide_menu():
	lobby_ui.hide()

func _on_ip_line_edit_text_submitted(_new_text: String) -> void:
	if ip_line_edit.text == GameManager.LOCAL_HOST:
		OnlineMang.Join.emit(ip_line_edit.text)
	else:
		OnlineMang.Join.emit(RoomGen.codeToIP(ip_line_edit.text))
	background_container.hide()
