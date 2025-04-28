extends Node

const LOCAL_HOST = "127.0.0.1"
const promptObj = preload("uid://di0pgx52tsecd")
var PLAYER: Player

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


func _ready() -> void:
	pass



func spawn_point_rng():
	randomize()
	#get spawn points
	var points = get_tree().get_nodes_in_group("Spawn_Point")
	var spawnPOS = points.pick_random()
	return spawnPOS

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		ConfigFileHandler.save_user_settings("name",SettingsManager.UserName)
		ConfigFileHandler.save_user_settings("save_version",SettingsManager.Save_version)
		ConfigFileHandler.save_mouse_settings("sensitivity", SettingsManager.MouseSensitivity)
		ConfigFileHandler.save_audio_settings("master_audio",SettingsManager.MasterVol)
		ConfigFileHandler.save_audio_settings("music_audio",SettingsManager.MusicVol)
		ConfigFileHandler.save_audio_settings("sfx_audio",SettingsManager.SFXVol)
		ConfigFileHandler.save_audio_settings("foot_audio",SettingsManager.FootVol)
		ConfigFileHandler.save_audio_settings("menu_audio",SettingsManager.MenuVol)
		ConfigFileHandler.save_graphic_settings("resolution",SettingsManager.current_res)
		ConfigFileHandler.save_graphic_settings("screen_focus",SettingsManager.screen_focus)
		ConfigFileHandler.save_graphic_settings("fullscreen",SettingsManager.FullscreenBool)
		await get_tree().create_timer(0.01).timeout
		get_tree().quit()

func fire_prompt(text:String, parent:Node):
	var promptCopy = promptObj.instantiate()
	parent.add_child(promptCopy)
	promptCopy.set_data(text)
