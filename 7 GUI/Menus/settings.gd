extends Control

@export var edit_name: bool = true
@onready var audio_master: LineEdit = $"GridContainer/Audio/CenterContainer/MarginContainer/GridContainer/VBoxContainer/Master Text/GridContainer/MasterEdit"
@onready var audio_music: LineEdit = $"GridContainer/Audio/CenterContainer/MarginContainer/GridContainer/VBoxContainer/Music Text/GridContainer/MusicEdit"
@onready var audio_sfx: LineEdit = $"GridContainer/Audio/CenterContainer/MarginContainer/GridContainer/VBoxContainer/SFX Text/GridContainer/SFXEdit"
@onready var audio_foot: LineEdit = $"GridContainer/Audio/CenterContainer/MarginContainer/GridContainer/VBoxContainer/Foot Text/GridContainer/FootEdit"
@onready var player_name: LineEdit = $GridContainer/User/CenterContainer/MarginContainer/GridContainer/VBoxContainer/player_name
@onready var mouse_sens: LineEdit = $GridContainer/User/CenterContainer/MarginContainer/GridContainer/VBoxContainer/GridContainer/LineEdit

#menus
@onready var audio: PanelContainer = $GridContainer/Audio
@onready var graphics: PanelContainer = $GridContainer/Graphics
@onready var keybinds: PanelContainer = $GridContainer/Keybinds
@onready var user: PanelContainer = $GridContainer/User

var active_menu = null
var Text_Focused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_name.text = GameManager.UserName
	player_name.editable = edit_name
	active_menu = audio
	audio.hide()
	graphics.hide()
	keybinds.hide()
	user.hide()
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Text_Focused:
		update_text()


func _on_player_name_text_changed(new_text: String) -> void:
	GameManager.UserName = new_text


func update_text():
	mouse_sens.text = str(GameManager.sensitivity)
	audio_master.text = str(GameManager.master_audio)
	audio_music.text = str(GameManager.music_audio)
	audio_sfx.text = str(GameManager.sfx_audio)
	audio_foot.text = str(GameManager.foot_audio)


func _audio_pressed() -> void:
	if active_menu != null:
		active_menu.hide()
		audio.show()
		active_menu = audio


func _graphics_pressed() -> void:
	if active_menu != null:
		active_menu.hide()
		graphics.show()
		active_menu = graphics


func _keybinds_pressed() -> void:
	if active_menu != null:
		active_menu.hide()
		keybinds.show()
		active_menu = keybinds


func _user_pressed() -> void:
	if active_menu != null:
		active_menu.hide()
		user.show()
		active_menu = user
