extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected
var ip: String


const PORT = 7000
const MAX_CONNECTIONS = 8

var players = {}
@export var matchSettings: Dictionary = {"skill_Cooldown":0,"skill1_radius":0,"player_Speed":0,"player_jump":0}
var weaponList = {}

var testStringPlease: String
var player_info = {"name": SettingsManager.UserName, "kills": 0, "deaths": 0}



func _ready() -> void:
	OnlineMang.Host.connect(create_game)
	OnlineMang.Join.connect(join_game)
	OnlineMang.PlayerDied.connect(player_died)
	OnlineMang.onlineComp = self
	
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			
			var map_result_udp = upnp.add_port_mapping(PORT, PORT, "godot_udp", "UDP", 0)
			var map_result_tcp = upnp.add_port_mapping(PORT, PORT, "godot_udp", "TCP", 0)
			#print("port forwarded")
			if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(PORT, PORT, "", "UDP")
			
			if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(PORT, PORT, "", "TCP")
			ip = upnp.query_external_address()
			OnlineMang.Host_IP = ip
	
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	players[1] = player_info
	update_MatchSettings.rpc(OnlineMang.serverInfo.matchSettings)
	update_weaponList.rpc(OnlineMang.serverInfo.Weapon_list)
	player_connected.emit(1, player_info)

func join_game(address):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

func _on_player_connected(id):
	if multiplayer.is_server():
		update_MatchSettings.rpc(OnlineMang.serverInfo.matchSettings)
		update_weaponList.rpc(OnlineMang.serverInfo.Weapon_list)
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	OnlineMang.PlayerDied.emit(-2,new_player_id)
	
func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_to_server():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)
	
	
	

func _on_connection_failed():
	multiplayer.multiplayer_peer = null
	
func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	GameManager.disconnected = true
	SceneLoad.Change_Scene(SceneLoad.Default_Scene)

@rpc("authority","call_local")
func update_globals(var1,var2, var3, var4):
	GameManager.skill_Cooldown = var1
	GameManager.skill1_radius = var2
	GameManager.player_Speed = var3
	GameManager.player_jump = var4

@rpc("authority","call_local")
func update_MatchSettings(var1):
	matchSettings = var1
	
@rpc("authority","call_local")
func update_weaponList(var1):
	weaponList = var1

func player_died(killer,killed):
	var killed_name = players[killed].name
	
	if killer == -1:
		players[killed].deaths += 1
		GameManager.PLAYER.killfeed.send_message.rpc("Environment",killed_name)
	elif killer == -2:
		if GameManager.PLAYER:
			GameManager.PLAYER.killfeed.send_message.rpc("Connected",killed_name)
	else:
		var Killer_name = players[killer].name
		players[killer].kills += 1
		players[killed].deaths += 1
		GameManager.PLAYER.killfeed.send_message.rpc(Killer_name,killed_name)

func _exit_tree() -> void:
	OnlineMang.onlineComp = null

@rpc("authority","call_local")
func update_test(var1):
	testStringPlease = var1
