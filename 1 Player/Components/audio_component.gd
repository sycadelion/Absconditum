class_name AudioComp extends Node

@onready var footstep:AkEvent3D = $"../Footsteps"
@onready var skill_audio:AkEvent3D = %Skillaudio
@onready var bow_audio:AkEvent3D = %GunAudio

var Surface: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Surface = "Lino"

func _physics_process(_delta: float) -> void:
	pass

@rpc("call_local")
func Play_footstep(_surface:= Surface):
	Wwise.set_switch("MaterialFeet",_surface,footstep)
	footstep.post_event()

@rpc("call_local")
func Play_land():
	Wwise.set_switch("MaterialFeet","Boots",footstep)
	footstep.post_event()
	
@rpc("call_local")
func Play_shoot():
	bow_audio.post_event()
	
@rpc("call_local")
func Play_Throw_Skill():
	skill_audio.post_event()
