extends Control

#input setting things
@onready var input_button_scene = preload("uid://c3isvmwkrnlq")
@onready var action_list = %ActionList
var is_remapping = false
var action_to_remap = null
var remapping_button = null
var input_actions = {
	"up": "Forward",
	"down": "Backward",
	"left": "Left",
	"right": "Right",
	"jump": "Jump",
	"shoot": "Primary Fire",
	"altfire": "Alt. Fire",
	"Skill1": "Use Ability",
	"reload": "Reload",
	"crouch": "Crouch",
	"sprint": "Sprint",
	"Weapon1": "Weapon 1",
	"Weapon2": "Weapon 2",
	"Inventory": "Inventory",
	"quit": "Pause",
	"FPS": "FPS Overlay"
}

func _ready() -> void:
	_load_keybindings_from_settings()
	_create_action_list()

func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var remap_Scene = input_button_scene.instantiate()
		var action_button = remap_Scene.find_child("ActionButton")
		var input_label = remap_Scene.find_child("InputLabel")
		var events = InputMap.action_get_events(action)
		
		action_button.text = input_actions[action]
		
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(remap_Scene)
		action_button.pressed.connect(_on_input_button_pressed.bind(remap_Scene,action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("ActionButton").text = "Press key to bind..."

func _input(event: InputEvent) -> void:
	if is_remapping:
		if (
			event is InputEventKey || 
			(event is InputEventMouseButton && event.pressed)
		):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			remapping_button.find_child("ActionButton").text = input_actions[action_to_remap]
			ConfigFileHandler.save_keybinding(action_to_remap, event)
			_update_action_list(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _update_action_list(button, event):
	button.find_child("InputLabel").text = event.as_text().trim_suffix(" (Physical)")

func _on_reset_button_pressed() -> void:
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_keybinding(action,events[0])
	_create_action_list()

func _load_keybindings_from_settings():
	var keybindings = ConfigFileHandler.load_keybinding()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])
