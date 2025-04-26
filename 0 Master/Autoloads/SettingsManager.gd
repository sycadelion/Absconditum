class_name SettingsLoader extends Node

const save_path = "user://settings.ini"
#Graphic Settings
var FullscreenBool: bool = false
var resolutions_dic : Dictionary = {
								"640 x 360 - 16:9": Vector2i(640, 360),
								"960 x 540 - 16:9": Vector2i(960, 540),
								"1280 x 720 - 16:9": Vector2i(1280, 720),
								"1600 x 900 - 16:9": Vector2i(1600, 900),
								"1920 x 1080 - 16:9": Vector2i(1920, 1080),
								"2560 x 1440 - 16:9": Vector2i(2560, 1440),
								"576 x 360 - 16:10": Vector2i(576, 360),
								"864 x 540 - 16:10": Vector2i(864, 540),
								"1280 x 800 - 16:10": Vector2i(1280, 800),
								"1440 x 900 - 16:10": Vector2i(1440, 900),
								"1920 x 1200 - 16:10": Vector2i(1920, 1200),
								"2560 x 1600 - 16:10": Vector2i(2560, 1600),
								"640 x 480 - 4:3": Vector2i(640, 480),
								"960 x 720 - 4:3": Vector2i(960, 720),
								"1024 x 768 - 4:3": Vector2i(1024, 768),
								"1440 x 1080 - 4:3": Vector2i(1440, 1080),
								"1920 x 1440 - 4:3": Vector2i(1920, 1440)
								}

@onready var current_res: Vector2i = resolutions_dic["1280 x 720 - 16:9"]:
	set(value):
		current_res = value
		DisplayServer.window_set_size(value)
		DisplayServer.window_set_position(DisplayServer.screen_get_size()*.5-\
		DisplayServer.window_get_size() * .5)
		DisplayServer.window_set_current_screen(screen_focus)

var screen_focus: int = 0:
	set(value):
		screen_focus = value
		DisplayServer.window_set_current_screen(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(save_path):
		load_settings()
	else:
		GameManager.master_audio = Wwise.get_rtpc_value("MasterVol", null)
		GameManager.foot_audio = Wwise.get_rtpc_value("FootVol", null)
		GameManager.sfx_audio = Wwise.get_rtpc_value("SFXVol", null)
		GameManager.music_audio = Wwise.get_rtpc_value("MusicVol", null)
		GameManager.menu_audio = Wwise.get_rtpc_value("MenuVol", null)
		screen_focus = DisplayServer.get_primary_screen()
		GameManager.sensitivity = 5

func load_settings():
	var mouse_settings = ConfigFileHandler.load_mouse_settings()
	var audio_settings = ConfigFileHandler.load_audio_settings()
	var user_settings = ConfigFileHandler.load_user_settings()
	var graphic_settings = ConfigFileHandler.load_graphic_settings()
		
	GameManager.UserName = user_settings.name
	GameManager.sensitivity = mouse_settings.sensitivity
	GameManager.MasterVol = audio_settings.master_audio
	Wwise.set_rtpc_value("MasterVol",audio_settings.master_audio,null)
	GameManager.MusicVol = audio_settings.music_audio
	Wwise.set_rtpc_value("MusicVol",audio_settings.music_audio,null)
	GameManager.SFXVol = audio_settings.sfx_audio
	Wwise.set_rtpc_value("SFXVol",audio_settings.sfx_audio,null)
	GameManager.FootVol = audio_settings.foot_audio
	Wwise.set_rtpc_value("FootVol",audio_settings.foot_audio,null)
	GameManager.MenuVol = audio_settings.menu_audio
	Wwise.set_rtpc_value("MenuVol",audio_settings.menu_audio,null)
	screen_focus = graphic_settings.screen_focus
	current_res = graphic_settings.resolution
	FullscreenBool = graphic_settings.fullscreen
	if FullscreenBool:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
