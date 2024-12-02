extends Node

var host_mode = false
var mouseCap = true
var disconnected = false
var paused = false

#customize match settings:
var skill_Cooldown = 5
var skill1_radius = 10
var player_Speed = 5
var player_jump = 5
var hitscan:bool = false

#customize game settings:
var sensitivity: float = 0.005
var master_audio:int = 100
var music_audio:int = 100
var sfx_audio:int = 100
var foot_audio:int = 100

func spawn_point_rng():
	randomize()
	#get spawn points
	var points = get_tree().get_nodes_in_group("Spawn_Point")
	var spawnPOS = points.pick_random()
	return spawnPOS
