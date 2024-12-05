extends Node

const save_path = "user://settings.ini"

var host_mode = false
var mouseCap = true
var disconnected = false
var paused = false

#game version only changing for save files
var version: int = 1

#customize match settings:
var skill_Cooldown = 5
var skill1_radius = 10
var player_Speed = 5
var player_jump = 5
var hitscan:bool = false


#customize game settings:
var sensitivity: float = 0
var master_audio:int = 0
var music_audio:int = 0
var sfx_audio:int = 0
var foot_audio:int = 0

func _ready() -> void:
	if FileAccess.file_exists(save_path):
		var mouse_settings = ConfigFileHandler.load_mouse_settings()
		var audio_settings = ConfigFileHandler.load_audio_settings()
		var user_settings = ConfigFileHandler.load_user_settings()
		Lobby.player_info.name = user_settings.name
		sensitivity = mouse_settings.sensitivity
		master_audio = audio_settings.master_audio
		music_audio = audio_settings.music_audio
		sfx_audio = audio_settings.sfx_audio
		foot_audio = audio_settings.foot_audio
	else:
		sensitivity = 0.005
		master_audio = 100
		music_audio = 100
		sfx_audio = 100
		foot_audio = 100

func spawn_point_rng():
	randomize()
	#get spawn points
	var points = get_tree().get_nodes_in_group("Spawn_Point")
	var spawnPOS = points.pick_random()
	return spawnPOS

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		ConfigFileHandler.save_user_settings()
		ConfigFileHandler.save_mouse_settings("sensitivity", sensitivity)
		ConfigFileHandler.save_audio_settings("master_audio",master_audio)
		ConfigFileHandler.save_audio_settings("music_audio",music_audio)
		ConfigFileHandler.save_audio_settings("sfx_audio",sfx_audio)
		ConfigFileHandler.save_audio_settings("foot_audio",foot_audio)
		get_tree().quit()
