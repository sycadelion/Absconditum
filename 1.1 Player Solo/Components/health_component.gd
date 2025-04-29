class_name HealthCompSolo extends Node

@export var MAX_HEALTH:int = 10
var health: int
var hit = false
@onready var hurtbox: Area3D = $"../Hurtbox"

var Player: PlayerSolo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = owner
	health = MAX_HEALTH

func receive_damage(damage_value:int, attacker:int):
	if !hit:
		hit = true
		hurtbox.monitoring = false
		health -= damage_value
		await get_tree().create_timer(0.1).timeout
		hurtbox.monitoring = true
		hit = false
		if health <= 0:
			pass

func Heal_self():
	health = MAX_HEALTH
