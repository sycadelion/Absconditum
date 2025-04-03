extends Control

@onready var skill_cd: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Skill Settings/Skill_CD"
@onready var skill_radius: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Skill Settings/Skill_radius"
@onready var movement_speed: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Player Settings/MovementSpeed"
@onready var jump_height: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Player Settings/JumpHeight"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skill_cd.text = "Skill Cooldown: " + str(GameManager.skill_Cooldown)
	skill_radius.text = "Skill radius: " + str(GameManager.skill1_radius)
	movement_speed.text = "Movement Speed: " + str(GameManager.player_Speed)
	jump_height.text = "Jump Height: " + str(GameManager.player_jump)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	skill_cd.text = "Skill Cooldown: " + str(GameManager.skill_Cooldown)
	skill_radius.text = "Skill radius: " + str(GameManager.skill1_radius)
	movement_speed.text = "Movement Speed: " + str(GameManager.player_Speed)
	jump_height.text = "Jump Height: " + str(GameManager.player_jump)
