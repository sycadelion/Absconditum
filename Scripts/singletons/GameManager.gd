extends Node

const save_path = "user://settings.ini"
const FMOD_BANKS = preload("res://Scenes/fmod_banks.tscn")
const LOCAL_HOST = "127.0.0.1"

#fmod busses
var fmodbuses = {MasterBus=null,FootBus=null,SFXBus=null,MusicBus=null}

var host_mode = false
var mouseCap = true
var disconnected = false
var paused = false

#game version only changing for save files
var Save_version: int = 1

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
	var fmod_banks_add = FMOD_BANKS.instantiate()
	add_child(fmod_banks_add)
	fmodbuses[0] = FmodServer.get_bus("bus:/Master")
	fmodbuses[1] = FmodServer.get_bus("bus:/Master/Footsteps")
	fmodbuses[2] = FmodServer.get_bus("bus:/Master/SFX")
	fmodbuses[3] = FmodServer.get_bus("bus:/Master/Music")
	
	master_audio = fmodbuses[0].volume
	
	if FileAccess.file_exists(save_path):
		var mouse_settings = ConfigFileHandler.load_mouse_settings()
		var audio_settings = ConfigFileHandler.load_audio_settings()
		var user_settings = ConfigFileHandler.load_user_settings()
		Lobby.player_info.name = user_settings.name
		sensitivity = mouse_settings.sensitivity
		fmodbuses[0].volume = audio_settings.master_audio
		fmodbuses[3].volume = audio_settings.music_audio
		fmodbuses[2].volume = audio_settings.sfx_audio
		fmodbuses[1].volume = audio_settings.foot_audio
	else:
		sensitivity = 0.005
		fmodbuses[0].volume = 1
		fmodbuses[3].volume = 1
		fmodbuses[2].volume = 1
		fmodbuses[1].volume = 1

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
		ConfigFileHandler.save_audio_settings("master_audio",fmodbuses[0].volume)
		ConfigFileHandler.save_audio_settings("music_audio",fmodbuses[3].volume)
		ConfigFileHandler.save_audio_settings("sfx_audio",fmodbuses[2].volume)
		ConfigFileHandler.save_audio_settings("foot_audio",fmodbuses[1].volume)
		get_tree().quit()
