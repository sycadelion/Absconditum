extends CharacterBody3D

@export_range(0,2) var noiseSize:float
@export_range(0,5) var noiseSpeed:float
@export_range(0,3) var noiseStrength:float
@export_range(0,20) var sphereRadius:float
@export_range(0,1) var borderSize:float
@export_color_no_alpha var borderColor:Color
@export var invertCut:bool
@onready var bubble:MeshInstance3D = $Bubble
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var lifetime_timer: Timer = $Timer

var expanded: bool = false

func _ready() -> void:
	lifetime_timer.wait_time = GameManager.skill_Cooldown
	anim_player.get_animation("expand").track_set_key_value(0,1,GameManager.skill1_radius)
	bubble.mesh.set_radius(sphereRadius)
	bubble.mesh.set_height(sphereRadius*2)
	if not expanded:
		anim_player.play("expand")
	
func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var ShaderObjects = get_tree().get_nodes_in_group("VisibleObjectsShader")
	for renderObjects in ShaderObjects:
		if renderObjects.get("material_override") != null:
			var shaderMat:ShaderMaterial = renderObjects.material_override
			#pass shader the info it needs
			shaderMat.set_shader_parameter("spherePos",global_position)
			shaderMat.set_shader_parameter("sphereRadius",sphereRadius)
			shaderMat.set_shader_parameter("borderSize",borderSize)
			shaderMat.set_shader_parameter("borderColor",borderColor)
			shaderMat.set_shader_parameter("noiseSize",noiseSize)
			shaderMat.set_shader_parameter("noiseSpeed",noiseSpeed)
			shaderMat.set_shader_parameter("noiseStrength",noiseStrength)
			shaderMat.set_shader_parameter("invertCut",invertCut)
	
	bubble.mesh.set_radius(sphereRadius)
	bubble.mesh.set_height(sphereRadius*2)
	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "expand" and not expanded:
		expanded = true
		lifetime_timer.start()
	elif anim_name == "expand" and expanded:
		queue_free()

func _on_timer_timeout() -> void:
	anim_player.play_backwards("expand")
