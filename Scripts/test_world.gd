extends Node3D

@onready var main_menu: PanelContainer = $CanvasLayer/MainMenu
@onready var address_entry: LineEdit = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const PLAYER = preload("res://Scenes/player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_button_pressed() -> void:
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	
func _on_join_button_pressed() -> void:
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	add_child(player)
