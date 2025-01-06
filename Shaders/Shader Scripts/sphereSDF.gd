extends RigidBody3D

@export_range(0,2) var noiseSize:float
@export_range(0,5) var noiseSpeed:float
@export_range(0,3) var noiseStrength:float
@export_range(0,20) var sphereRadius:float
@export_range(0,1) var borderSize:float
@export_color_no_alpha var borderColor:Color
@export var invertCut:bool
@onready var bubble_in:MeshInstance3D = $Bubble_in
@onready var bubble_out: MeshInstance3D = $Bubble_out
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var lifetime_timer: Timer = $Timer
@onready var area_col: CollisionShape3D = $Area3D/Area_col
@onready var audPlayer: FmodEventEmitter3D = $Skill_audio

var area_shape:SphereShape3D = SphereShape3D.new()
var expanded: bool = false

func _ready() -> void:
	area_shape.radius = GameManager.skill1_radius - 1
	area_col.shape = area_shape
	lifetime_timer.wait_time = GameManager.skill_Cooldown
	anim_player.get_animation("expand").track_set_key_value(0,1,GameManager.skill1_radius)
	bubble_in.mesh.set_radius(sphereRadius)
	bubble_out.mesh.set_radius(sphereRadius)
	bubble_in.mesh.set_height(sphereRadius*2)
	bubble_out.mesh.set_height(sphereRadius*2)
	if not expanded:
		anim_player.play("expand")
	
func _process(_delta: float) -> void:
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
	
	bubble_in.mesh.set_radius(sphereRadius)
	bubble_out.mesh.set_radius(sphereRadius)
	bubble_in.mesh.set_height(sphereRadius*2)
	bubble_out.mesh.set_height(sphereRadius*2)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "expand" and not expanded:
		expanded = true
		lifetime_timer.start()
	elif anim_name == "expand" and expanded:
		queue_free()

func _on_timer_timeout() -> void:
	anim_player.play_backwards("expand")


func _on_body_entered(_body: Node) -> void:
	linear_damp = 0.3
	angular_damp = 1.5


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Players"):
		bubble_in.show()
		bubble_out.hide()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Players"):
		bubble_in.hide()
		bubble_out.show()
		
func play_audio():
	audPlayer.play()
