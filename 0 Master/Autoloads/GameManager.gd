extends Node

const LOCAL_HOST = "127.0.0.1"
const promptObj = preload("res://7 GUI/Menus/prompt.tscn")
var PLAYER: Player

var host_mode = false
var mouseCap = true
var disconnected = false
var paused = false
var UserName: String

#game version only changing for save files
var Save_version: int = 2
var emptyConfig: bool = true

#customize match settings:
var skill_Cooldown = 5
var skill1_radius = 10
var player_Speed = 5
var player_jump = 5
var hitscan:bool = false


#customize game settings:
var sensitivity: float = 5
var master_audio:int = 0
var music_audio:int = 0
var sfx_audio:int = 0
var foot_audio:int = 0
var menu_audio:int = 0
var palette

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Engine.get_process_frames() % 5 == 0:
		master_audio = Wwise.get_rtpc_value("MasterVol",null)
		music_audio = Wwise.get_rtpc_value("MusicVol",null)
		sfx_audio = Wwise.get_rtpc_value("SFXVol",null)
		foot_audio = Wwise.get_rtpc_value("FootVol",null)
		menu_audio = Wwise.get_rtpc_value("MenuVol",null)

func spawn_point_rng():
	randomize()
	#get spawn points
	var points = get_tree().get_nodes_in_group("Spawn_Point")
	var spawnPOS = points.pick_random()
	return spawnPOS

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		ConfigFileHandler.save_user_settings("name",GameManager.UserName)
		ConfigFileHandler.save_user_settings("save_version",GameManager.Save_version)
		ConfigFileHandler.save_mouse_settings("sensitivity", sensitivity)
		ConfigFileHandler.save_audio_settings("master_audio",master_audio)
		ConfigFileHandler.save_audio_settings("music_audio",music_audio)
		ConfigFileHandler.save_audio_settings("sfx_audio",sfx_audio)
		ConfigFileHandler.save_audio_settings("foot_audio",foot_audio)
		ConfigFileHandler.save_audio_settings("menu_audio",menu_audio)
		ConfigFileHandler.save_graphic_settings("resolution",SettingsManager.current_res)
		ConfigFileHandler.save_graphic_settings("screen_focus",SettingsManager.screen_focus)
		ConfigFileHandler.save_graphic_settings("fullscreen",SettingsManager.FullscreenBool)
		await get_tree().create_timer(0.01).timeout
		get_tree().quit()

func fire_prompt(text:String, parent:Node):
	var promptCopy = promptObj.instantiate()
	parent.add_child(promptCopy)
	promptCopy.set_data(text)
