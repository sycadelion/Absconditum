extends Control

@onready var skill_cd: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Skill Settings/Skill_CD"
@onready var skill_radius: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Skill Settings/Skill_radius"
@onready var movement_speed: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Player Settings/MovementSpeed"
@onready var jump_height: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Player Settings/JumpHeight"
@onready var hitscanCheck: CheckBox = $"PanelContainer/CenterContainer/MarginContainer/grid/Player Settings/CenterContainer/HitscanCheckBox"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skill_cd.text = "Skill Cooldown: " + str(GameManager.skill_Cooldown)
	skill_radius.text = "Skill radius: " + str(GameManager.skill1_radius)
	movement_speed.text = "Movement Speed: " + str(GameManager.player_Speed)
	jump_height.text = "Jump Height: " + str(GameManager.player_jump)
	hitscanCheck.button_pressed = GameManager.hitscan

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skill_cd.text = "Skill Cooldown: " + str(GameManager.skill_Cooldown)
	skill_radius.text = "Skill radius: " + str(GameManager.skill1_radius)
	movement_speed.text = "Movement Speed: " + str(GameManager.player_Speed)
	jump_height.text = "Jump Height: " + str(GameManager.player_jump)


func _on_hitscan_check_box_toggled(toggled_on: bool) -> void:
	GameManager.hitscan = toggled_on
