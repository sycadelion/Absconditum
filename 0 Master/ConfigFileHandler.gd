extends Node

const save_path = "user://settings.ini"

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(save_path):
		config.set_value("User","name",Lobby.player_info.name)
		config.set_value("User","save_version",GameManager.Save_version)
		config.set_value("Mouse","sensitivity",GameManager.sensitivity)
		config.set_value("Audio","master_audio",GameManager.master_audio)
		config.set_value("Audio","music_audio",GameManager.music_audio)
		config.set_value("Audio","sfx_audio",GameManager.sfx_audio)
		config.set_value("Audio","foot_audio",GameManager.foot_audio)
		
		config.save(save_path)
	else:
		config.load(save_path)

func save_mouse_settings(key: String, value):
	config.set_value("Mouse",key,value)
	config.save(save_path)
	
func load_mouse_settings():
	config.load(save_path)
	var mouse_settings = {}
	for keys in config.get_section_keys("Mouse"):
		mouse_settings[keys] = config.get_value("Mouse", "sensitivity")
	return mouse_settings

func save_audio_settings(key: String, value):
	config.set_value("Audio",key,value)
	config.save(save_path)
	
func load_audio_settings():
	config.load(save_path)
	var audio_settings = {}
	for key in config.get_section_keys("Audio"):
		audio_settings[key] = config.get_value("Audio", key)
	return audio_settings
	
func save_user_settings():
	config.set_value("User","name",Lobby.player_info.name)
	config.save(save_path)
	
func load_user_settings():
	config.load(save_path)
	var user_settings = {}
	for key in config.get_section_keys("User"):
		user_settings[key] = config.get_value("User", key)
	return user_settings
