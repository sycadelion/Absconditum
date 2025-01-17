class_name SceneLoader extends Node

##Scenes and Transitions
@export_group("Scenes and Transitions")
@export var Default_Scene: PackedScene ##The Scene that is loaded on runtime
@export var Current_Scene: Node ##The Scene that is currently active and shown
@export var Next_Scene: PackedScene ##The next Scene that is loading
@export var Load_Scene: PackedScene ##The loading screen scene

##Component Scenes
@export_group("Component Scenes")
@export var online_connection: PackedScene ##Online script component node
@export var Fmod_Component: PackedScene ##Fmod banks component

##Container Nodes
@onready var Components: Node =  %"Component Container"
@onready var Scenes: Node = %Scene
@onready var players_container: Node = %"Players Container"
@onready var effect_container: Node = %"Effect Container"
@onready var menus: CanvasLayer = %Menus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_component(Fmod_Component)
	load_scene(Default_Scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

##Load a component and add it to the component container
func load_component(_component) -> void:
	Components.add_child(_component.instantiate())

##loads scene, deletes previous scene, updates current scene
func load_scene(_scene) -> void:
	var to_load_scene = _scene.instantiate()
	if to_load_scene != Current_Scene:
		for c in Scenes.get_children():
			Scenes.remove_child(c)
			c.queue_free()
		Scenes.add_child(to_load_scene)
		Current_Scene = to_load_scene
