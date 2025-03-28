class_name AudioComp extends Node

@onready var footstep:AkEvent3D = $"../Footsteps"
@onready var skill_audio:AkEvent3D = %Skillaudio
@onready var bow_audio:AkEvent3D = %GunAudio
@onready var voice: AkEvent3D = $"../Head/Camera3D/Voice"

var Surface: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Surface = "Lino"

func _physics_process(_delta: float) -> void:
	pass

@rpc("call_local")
func Play_footstep(_surface:= Surface):
	Wwise.set_switch("MaterialFeet",_surface,footstep)
	if owner.is_on_floor():
		footstep.post_event()

@rpc("call_local")
func Play_jump():
	Wwise.set_switch("PlayerVoice","Jump",voice)
	voice.post_event()

@rpc("call_local")
func Play_land():
	Wwise.set_switch("MaterialFeet","Boots",footstep)
	Wwise.set_switch("PlayerVoice","Land",voice)
	footstep.post_event()
	voice.post_event()
	
@rpc("call_local")
func Play_shoot():
	bow_audio.post_event()
	
@rpc("call_local")
func Play_Throw_Skill():
	skill_audio.post_event()
