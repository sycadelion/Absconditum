class_name SettingsLoader extends Node

const save_path = "user://settings.ini"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.fmodbuses[0] = FmodServer.get_bus("bus:/Master")
	GameManager.fmodbuses[1] = FmodServer.get_bus("bus:/Master/Footsteps")
	GameManager.fmodbuses[2] = FmodServer.get_bus("bus:/Master/SFX")
	GameManager.fmodbuses[3] = FmodServer.get_bus("bus:/Master/Music")
	
	GameManager.master_audio = GameManager.fmodbuses[0].volume
	
	if FileAccess.file_exists(save_path):
		var mouse_settings = ConfigFileHandler.load_mouse_settings()
		var audio_settings = ConfigFileHandler.load_audio_settings()
		var user_settings = ConfigFileHandler.load_user_settings()
		GameManager.UserName = user_settings.name
		GameManager.sensitivity = mouse_settings.sensitivity
		GameManager.fmodbuses[0].volume = audio_settings.master_audio
		GameManager.fmodbuses[3].volume = audio_settings.music_audio
		GameManager.fmodbuses[2].volume = audio_settings.sfx_audio
		GameManager.fmodbuses[1].volume = audio_settings.foot_audio
	else:
		GameManager.sensitivity = 5
		GameManager.fmodbuses[0].volume = 1
		GameManager.fmodbuses[3].volume = 1
		GameManager.fmodbuses[2].volume = 1
		GameManager.fmodbuses[1].volume = 1
