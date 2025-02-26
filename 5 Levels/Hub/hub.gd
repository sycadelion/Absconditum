extends Node3D

@export var players_container: Node3D
@export var player_scene: PackedScene
@export var player_spawner: MultiplayerSpawner

@onready var spawning_cam: Camera3D = $"Spawning Cam"
@onready var ingame_stuff: CanvasLayer = $"Ingame Stuff"
@onready var slot_1: OptionButton = $"Ingame Stuff/Spawn Screen/PanelContainer/VBoxContainer/Slot 1"
@onready var slot_2: OptionButton = $"Ingame Stuff/Spawn Screen/PanelContainer/VBoxContainer/Slot 2"

var local_id

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
	
	#set player to spawn position
	player_instance.name = str(id)
	var spawnPOS = GameManager.spawn_point_rng()
	if spawnPOS.SpawnActive:
		player_instance.global_position = spawnPOS.SpawnPOS
		print("player " + str(player_instance.player_id) + " Spawned" + " at " + str(spawnPOS.SpawnPOS))
	else:
		spawnPOS = GameManager.spawn_point_rng()
	
	spawning_cam.current = false
	return player_instance

func add_player(id):
	player_count += 1
	local_id = id

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

func _on_button_pressed() -> void:
	GameManager.dead = false
	GameManager.slot_1 = slot_1.get_item_text(slot_1.selected)
	GameManager.slot_2 = slot_2.get_item_text(slot_2.selected)
	player_spawner.spawn(local_id)
	ingame_stuff.hide()
	

func _physics_process(delta: float) -> void:
	if GameManager.dead:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		spawning_cam.current = true
		ingame_stuff.show()
