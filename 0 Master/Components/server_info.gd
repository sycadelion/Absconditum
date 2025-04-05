extends Node

@export var weapon_resouces: Array[WeaponResource]
@export var Weapon_list = {}

@export var matchSettings: Dictionary = {"skill_Cooldown":5,"skill1_radius":10,"player_Speed":5,"player_jump":5, "player_sprint": 3}
var testingString = "wow look it does work"

func _ready() -> void:
	OnlineMang.serverInfo = self
	for weapon in weapon_resouces:
		Weapon_list[weapon.Weapon_name] = inst_to_dict(weapon)

@rpc("authority","call_local")
func update_MatchSettings() -> Dictionary:
	return matchSettings
