extends HSlider

@export var settingsVar: String
var gunSettingVar: String
@export var minV = 0
@export var maxV = 100
@export var is_audio: bool
@export var MatchSetting: bool
@export var gunSetting: bool
@export var bus_index: int
var setValue: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_audio and not gunSetting:
		setValue = GameManager.get(settingsVar)
	elif is_audio:
		setValue = Wwise.get_rtpc_value_id(bus_index,null)
	value = setValue
	min_value = minV
	max_value = maxV

func _on_value_changed(valueVar: float) -> void:
	if not is_audio and not MatchSetting and not gunSetting:
		GameManager.set(settingsVar, valueVar)
	elif is_audio and not MatchSetting:
		Wwise.set_rtpc_value_id(bus_index,valueVar,null)
	elif MatchSetting and not is_audio and not gunSetting:
		if OnlineMang.serverInfo:
			OnlineMang.serverInfo.matchSettings[settingsVar] = valueVar
	elif gunSetting and not is_audio and not MatchSetting:
		if OnlineMang.serverInfo:
			pass
			#OnlineMang.serverInfo.Weapon_list[settingsVar][gunSettingVar] = int(valueVar)



func _on_mouse_exited() -> void:
	self.release_focus()
