extends Node3D

@export var players_container: Node3D
@export var player_scene: PackedScene
@export var player_spawner: MultiplayerSpawner

var player_count = 0

func _enter_tree() -> void:
	pass

func _ready() -> void:
	await get_tree().process_frame
	player_spawner.spawn_function = spawn_player
	player_count = 0
	
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_disconnected.connect(delete_player)
	multiplayer.peer_connected.connect(player_joined)
	
	add_player(1)
	
	for id in multiplayer.get_peers():
		add_player(id)
		

func spawn_player(id):
	var player_instance = player_scene.instantiate()
	
	
	#set player id
	player_instance.player_id = id
	
	
	print("player " + str(player_instance.player_id) + " Spawned")
	#set player to spawn position
	player_instance.name = str(id)
	var spawnPOS = GameManager.spawn_point_rng()
	if spawnPOS.SpawnActive:
		player_instance.global_position = spawnPOS.SpawnPOS
		print("player " + str(player_instance.player_id) + " Spawned" + " at " + str(spawnPOS.SpawnPOS))
	else:
		spawnPOS = GameManager.spawn_point_rng()
	
	return player_instance

func add_player(id):
	player_count += 1
	player_spawner.spawn(id)

func player_joined(id):
	add_player(id)

func _exit_tree() -> void:
	if not multiplayer.is_server():
		return
	multiplayer.peer_disconnected.connect(delete_player)
	
func delete_player(id):
	if not players_container.has_node(str(id)):
		return
	
	players_container.get_node(str(id)).queue_free()
	
