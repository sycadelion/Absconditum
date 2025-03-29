extends Node

const save_path = "user://settings.ini"

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(save_path):
		set_defaults()
		config.save(save_path)
	else:
		config.load(save_path)
		var save_ver = ConfigFileHandler.load_user_settings()
		if save_ver.save_version != GameManager.Save_version:
			config.clear()
			set_defaults()
			config.save(save_path)
			config.load(save_path)
		else:
			return

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
	
func save_user_settings(key: String, value):
	config.set_value("User",key,value)
	config.save(save_path)
	
func load_user_settings():
	config.load(save_path)
	var user_settings = {}
	for key in config.get_section_keys("User"):
		user_settings[key] = config.get_value("User", key)
	return user_settings

func save_graphic_settings(key: String, value):
	config.set_value("Graphic",key,value)
	config.save(save_path)
	
func load_graphic_settings():
	config.load(save_path)
	var graphic_settings = {}
	for key in config.get_section_keys("Graphic"):
		graphic_settings[key] = config.get_value("Graphic", key)
	return graphic_settings

func set_defaults():
	config.set_value("User","name",GameManager.UserName)
	config.set_value("User","save_version",GameManager.Save_version)
	config.set_value("Mouse","sensitivity",5)
	config.set_value("Audio","master_audio",GameManager.master_audio)
	config.set_value("Audio","music_audio",GameManager.music_audio)
	config.set_value("Audio","sfx_audio",GameManager.sfx_audio)
	config.set_value("Audio","foot_audio",GameManager.foot_audio)
	config.set_value("Audio","menu_audio",GameManager.menu_audio)
	config.set_value("Graphic","resolution",SettingsManager.resolutions_dic.get("1280 x 720 - 16:9"))
	config.set_value("Graphic","fullscreen",false)
	config.set_value("Graphic","screen_focus",DisplayServer.get_primary_screen())
