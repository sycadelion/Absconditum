extends Control

@onready var skill_cd: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Skill Settings/Skill_CD"
@onready var skill_radius: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Skill Settings/Skill_radius"
@onready var movement_speed: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Player Settings/MovementSpeed"
@onready var jump_height: Label = $"PanelContainer/CenterContainer/MarginContainer/grid/Player Settings/JumpHeight"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OnlineMang.serverInfo:
		skill_cd.text = "Skill Cooldown: " + str(OnlineMang.serverInfo.matchSettings.skill_Cooldown)
		skill_radius.text = "Skill radius: " + str(OnlineMang.serverInfo.matchSettings.skill1_radius)
		movement_speed.text = "Movement Speed: " + str(OnlineMang.serverInfo.matchSettings.player_Speed)
		jump_height.text = "Jump Height: " + str(OnlineMang.serverInfo.matchSettings.player_jump)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if OnlineMang.serverInfo:
		skill_cd.text = "Skill Cooldown: " + str(OnlineMang.serverInfo.matchSettings.skill_Cooldown)
		skill_radius.text = "Skill radius: " + str(OnlineMang.serverInfo.matchSettings.skill1_radius)
		movement_speed.text = "Movement Speed: " + str(OnlineMang.serverInfo.matchSettings.player_Speed)
		jump_height.text = "Jump Height: " + str(OnlineMang.serverInfo.matchSettings.player_jump)
