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
	player_name.text = GameManager.UserName
	player_name.editable = edit_name
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_text()


func _on_player_name_text_changed(new_text: String) -> void:
	GameManager.UserName = new_text


func update_text():
	mouse_sens.text = "Mouse Sensitivity : " + str(GameManager.sensitivity)
	audio_master.text = "Master Audio: " + str(round(100*GameManager.fmodbuses[0].volume))
	audio_music.text = "Music Audio: " + str(round(100*GameManager.fmodbuses[3].volume))
	audio_sfx.text = "SFX Audio: " + str(round(100*GameManager.fmodbuses[2].volume))
	audio_foot.text = "Footsteps Audio: " + str(round(100*GameManager.fmodbuses[1].volume))
