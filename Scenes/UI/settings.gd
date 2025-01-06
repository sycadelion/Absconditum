extends Control

@export var edit_name: bool = true
@onready var mouse_sens: Label = $PanelContainer/CenterContainer/MarginContainer/GridContainer/VBoxContainer/MouseSens
@onready var audio_master: Label = $PanelContainer/CenterContainer/MarginContainer/GridContainer/VBoxContainer/AudioMaster
@onready var audio_music: Label = $PanelContainer/CenterContainer/MarginContainer/GridContainer/VBoxContainer/AudioMusic
@onready var audio_sfx: Label = $PanelContainer/CenterContainer/MarginContainer/GridContainer/VBoxContainer/AudioSFX
@onready var audio_foot: Label = $PanelContainer/CenterContainer/MarginContainer/GridContainer/VBoxContainer/AudioFoot
@onready var player_name: LineEdit = $PanelContainer/CenterContainer/MarginContainer/GridContainer/VBoxContainer/player_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_name.text = Lobby.player_info["name"]
	player_name.editable = edit_name
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_text()


func _on_player_name_text_changed(new_text: String) -> void:
	Lobby.player_info["name"] = new_text


func update_text():
	mouse_sens.text = "Mouse Sensitivity : " + str(GameManager.sensitivity)
	audio_master.text = "Master Audio: " + str(round(100*db_to_linear(AudioServer.get_bus_volume_db(0))))
	audio_music.text = "Music Audio: " + str(round(100*db_to_linear(AudioServer.get_bus_volume_db(1))))
	audio_sfx.text = "SFX Audio: " + str(round(100*db_to_linear(AudioServer.get_bus_volume_db(2))))
	audio_foot.text = "Footsteps Audio: " + str(round(100*db_to_linear(AudioServer.get_bus_volume_db(3))))
