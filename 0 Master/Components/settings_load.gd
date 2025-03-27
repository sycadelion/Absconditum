class_name SettingsLoader extends Node

const save_path = "user://settings.ini"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.master_audio = Wwise.get_rtpc_value("MasterVol", null)
	GameManager.foot_audio = Wwise.get_rtpc_value("FootVol", null)
	GameManager.sfx_audio = Wwise.get_rtpc_value("SFXVol", null)
	GameManager.music_audio = Wwise.get_rtpc_value("MusicVol", null)
	GameManager.menu_audio = Wwise.get_rtpc_value("MenuVol", null)
	
	if FileAccess.file_exists(save_path):
		var mouse_settings = ConfigFileHandler.load_mouse_settings()
		var audio_settings = ConfigFileHandler.load_audio_settings()
		var user_settings = ConfigFileHandler.load_user_settings()
		GameManager.UserName = user_settings.name
		GameManager.sensitivity = mouse_settings.sensitivity
		GameManager.master_audio = audio_settings.master_audio
		GameManager.music_audio = audio_settings.music_audio
		GameManager.sfx_audio = audio_settings.sfx_audio
		GameManager.foot_audio = audio_settings.foot_audio
		GameManager.menu_audio = audio_settings.menu_audio
	else:
		GameManager.sensitivity = 5
		GameManager.master_audio = 100
		GameManager.music_audio = 100
		GameManager.sfx_audio = 100
		GameManager.foot_audio = 100
		GameManager.menu_audio = 100
