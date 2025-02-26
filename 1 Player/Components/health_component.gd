class_name HealthComp extends Node

@export var MAX_HEALTH:int = 10.0
var health: int

@onready var killfeed: Control = %KillFeed

var Player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = owner
	health = MAX_HEALTH

@rpc("any_peer")
func receive_damage(damage_value:int, attacker:int):
	health -= damage_value
	if health <= 0:
		OnlineMang.PlayerDied.emit(attacker,Player.owner_id)
		health = MAX_HEALTH
		GameManager.dead = true
		Player.queue_free()

@rpc("any_peer")
func respawn_self():
	var spawnPOS = GameManager.spawn_point_rng()
	if spawnPOS.SpawnActive:
		Player.position = spawnPOS.SpawnPOS
	else:
		spawnPOS = GameManager.spawn_point_rng()
