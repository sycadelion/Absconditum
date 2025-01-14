class_name AudioComp extends Node

@onready var footstep: FmodEventEmitter3D = $"../Footstep"
@onready var skill_audio: FmodEventEmitter3D = $"../Camera3D/Skill1Marker/Skill_audio"
@onready var bow_audio: FmodEventEmitter3D = $"../Camera3D/Bow_audio"

var Surface: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Surface = "Metal Grate"

@rpc("call_local")
func Play_footstep(_surface:= Surface):
	footstep.set_parameter("Surface",_surface)
	footstep.play()

@rpc("call_local")
func Play_land():
	footstep.set_parameter("Surface","Jump")
	footstep.play()
	
@rpc("call_local")
func Play_bow():
	bow_audio.play()
	
@rpc("call_local")
func Play_Throw_Skill():
	skill_audio.play()
