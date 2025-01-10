class_name HealthComp extends Node



@export var MAX_HEALTH:int = 10.0
var health: int

@onready var killfeed: Control = $"../CanvasLayer/KillFeed"

var Player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = owner
	health = MAX_HEALTH


@rpc("any_peer")
func receive_damage(damage_value:int, attacker:int):
	health -= damage_value
	if health <= 0:
		Lobby.players[Player.owner_id].deaths += 1
		Lobby.players[attacker].kills += 1
	
		health = MAX_HEALTH
		respawn_self()

@rpc("any_peer")
func respawn_self():
	var spawnPOS = GameManager.spawn_point_rng()
	if spawnPOS.SpawnActive:
		Player.position = spawnPOS.SpawnPOS
	else:
		spawnPOS = GameManager.spawn_point_rng()
