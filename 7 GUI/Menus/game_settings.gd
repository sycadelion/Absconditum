extends Control

@onready var skill_cd: Label = %Skill_CD_Text
@onready var skill_radius: Label = %Skill_radius_text
@onready var movement_speed: Label = %MovementSpeed_text
@onready var jump_height: Label = %JumpHeight_text
@onready var gun_dropdown: OptionButton = %GunDropdown

@onready var damage_set: HSlider = $GridContainer/Guns/CenterContainer/MarginContainer/GridContainer/VBoxContainer/DamageSet
@onready var damage_text: Label = $GridContainer/Guns/CenterContainer/MarginContainer/GridContainer/VBoxContainer/Damage/GridContainer/Damage_text


@onready var player_menu: PanelContainer = $GridContainer/Player
@onready var skills_menu: PanelContainer = $GridContainer/Skills
@onready var guns_menu: PanelContainer = $GridContainer/Guns

var active_menu = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_menu.hide()
	skills_menu.hide()
	guns_menu.hide()
	
	active_menu = player_menu
	active_menu.show()

	if OnlineMang.serverInfo:
		skill_cd.text = str(OnlineMang.serverInfo.matchSettings.skill_Cooldown)
		skill_radius.text = str(OnlineMang.serverInfo.matchSettings.skill1_radius)
		movement_speed.text = str(OnlineMang.serverInfo.matchSettings.player_Speed)
		jump_height.text = str(OnlineMang.serverInfo.matchSettings.player_jump)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if OnlineMang.serverInfo:
		if gun_dropdown.item_count < OnlineMang.serverInfo.Weapon_list.size():
			update_list()
		skill_cd.text = str(OnlineMang.serverInfo.matchSettings.skill_Cooldown)
		skill_radius.text = str(OnlineMang.serverInfo.matchSettings.skill1_radius)
		movement_speed.text = str(OnlineMang.serverInfo.matchSettings.player_Speed)
		jump_height.text = str(OnlineMang.serverInfo.matchSettings.player_jump)
		
		damage_set.settingsVar = str(OnlineMang.serverInfo.Weapon_list[gun_dropdown.get_item_text(gun_dropdown.selected)])
		damage_set.gunSettingVar = "Damage"
		damage_text.text = str(OnlineMang.serverInfo.Weapon_list[gun_dropdown.get_item_text(gun_dropdown.selected)].Damage)

func update_list():
	for weapon in OnlineMang.serverInfo.Weapon_list:
		gun_dropdown.add_item(weapon)

func _on_playerMenu_pressed() -> void:
	if active_menu != null:
		active_menu.hide()
		player_menu.show()
		active_menu = player_menu


func _on_skillMenu_pressed() -> void:
	if active_menu != null:
		active_menu.hide()
		skills_menu.show()
		active_menu = skills_menu


func _on_gunMenu_pressed() -> void:
	if active_menu != null:
		active_menu.hide()
		guns_menu.show()
		active_menu = guns_menu
