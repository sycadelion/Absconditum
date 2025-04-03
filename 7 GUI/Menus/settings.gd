extends Control

@onready var menu_audio: AkEvent2D = $MenuAudio
@export var palettes = []
@export var edit_name: bool = true
@onready var audio_master: LineEdit = $"GridContainer/Audio/CenterContainer/MarginContainer/GridContainer/VBoxContainer/Master Text/GridContainer/MasterEdit"
@onready var audio_music: LineEdit = $"GridContainer/Audio/CenterContainer/MarginContainer/GridContainer/VBoxContainer/Music Text/GridContainer/MusicEdit"
@onready var audio_sfx: LineEdit = $"GridContainer/Audio/CenterContainer/MarginContainer/GridContainer/VBoxContainer/SFX Text/GridContainer/SFXEdit"
@onready var audio_foot: LineEdit = $"GridContainer/Audio/CenterContainer/MarginContainer/GridContainer/VBoxContainer/Foot Text/GridContainer/FootEdit"
@onready var player_name: LineEdit = $GridContainer/User/CenterContainer/MarginContainer/GridContainer/VBoxContainer/player_name
@onready var mouse_sens: LineEdit = %sensText
@onready var palette_button: OptionButton = $GridContainer/Graphics/CenterContainer/MarginContainer/GridContainer/VBoxContainer/GridContainer/PaletteSelc/palette_button

#menus
@onready var audio: PanelContainer = $GridContainer/Audio
@onready var graphics: PanelContainer = $GridContainer/Graphics
@onready var keybinds: PanelContainer = $GridContainer/Keybinds
@onready var user: PanelContainer = $GridContainer/User

var active_menu = null
var Text_Focused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.palette = palettes[palette_button.selected]
	var index = 0
	#adds list of resolutions
	for r in SettingsManager.resolutions_dic:
		%resoDrop.add_item(r,index)
		index += 1
	
	#adds list of screens
	index = 0
	for d in DisplayServer.get_screen_count():
		%PrimaryDrop.add_item("Screen " + str(d+1),index)
		index += 1
	
	player_name.text = GameManager.UserName
	player_name.editable = edit_name
	active_menu = audio
	audio.show()
	graphics.hide()
	keybinds.hide()
	user.hide()
	update_text()
	_check_settings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_check_settings()
	if not Text_Focused:
		update_text()


func _on_player_name_text_changed(new_text: String) -> void:
	GameManager.UserName = new_text


func update_text():
	player_name.text = GameManager.UserName
	mouse_sens.text = str(GameManager.sensitivity)
	audio_master.text = str(GameManager.master_audio)
	audio_music.text = str(GameManager.music_audio)
	audio_sfx.text = str(GameManager.sfx_audio)
	audio_foot.text = str(GameManager.foot_audio)


func _audio_pressed() -> void:
	mouse_click()
	if active_menu != null:
		active_menu.hide()
		audio.show()
		active_menu = audio


func _graphics_pressed() -> void:
	mouse_click()
	if active_menu != null:
		active_menu.hide()
		graphics.show()
		active_menu = graphics


func _keybinds_pressed() -> void:
	mouse_click()
	if active_menu != null:
		active_menu.hide()
		keybinds.show()
		active_menu = keybinds


func _user_pressed() -> void:
	mouse_click()
	if active_menu != null:
		active_menu.hide()
		user.show()
		active_menu = user

func _change_resolution(index):
	SettingsManager.current_res = SettingsManager.resolutions_dic.get(%resoDrop.get_item_text(index))

func _change_screen(index):
	SettingsManager.screen_focus = index

func _check_settings():
	# Visuals
	var index = 0
	for r in SettingsManager.resolutions_dic:
		if SettingsManager.resolutions_dic[r] == SettingsManager.current_res:
			%resoDrop.select(index)
		index += 1
	#%ModeDrop.selected = SettingsManager.screen_mod
	%PrimaryDrop.selected = SettingsManager.screen_focus
	%FullscreenCheck.button_pressed = SettingsManager.FullscreenBool


func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	mouse_click()
	SettingsManager.FullscreenBool = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func mouse_hover():
	if menu_audio:
		Wwise.set_switch("Menus","Hover",menu_audio)
		menu_audio.post_event()

func mouse_click():
	if menu_audio:
		Wwise.set_switch("Menus","Click",menu_audio)
		menu_audio.post_event()


func _on_palette_button_item_selected(index: int) -> void:
	GameManager.palette = palettes[index]
