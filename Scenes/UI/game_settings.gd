extends Control

@onready var skill_cd: Label = $PanelContainer/CenterContainer/MarginContainer/VBoxContainer/HBoxContainer/Skill_CD
@onready var skill_radius: Label = $PanelContainer/CenterContainer/MarginContainer/VBoxContainer/HBoxContainer/Skill_radius

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skill_cd.text = "Skill Cooldown: " + str(GameManager.skill_Cooldown)
	skill_radius.text = "Skill radius: " + str(GameManager.skill1_radius)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skill_cd.text = "Skill Cooldown: " + str(GameManager.skill_Cooldown)
	skill_radius.text = "Skill radius: " + str(GameManager.skill1_radius)
