extends Node3D

@export_range(0,2) var noiseSize:float
@export_range(0,5) var noiseSpeed:float
@export_range(0,3) var noiseStrength:float
@export_range(0,20) var sphereRadius:float
@export_range(0,1) var borderSize:float
@export_color_no_alpha var borderColor:Color
@export var invertCut:bool
@onready var bubble:MeshInstance3D = $Bubble

func _ready() -> void:
	bubble.mesh.set_radius(sphereRadius)
	bubble.mesh.set_height(sphereRadius*2)
	
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
	
	bubble.mesh.set_radius(sphereRadius)
	bubble.mesh.set_height(sphereRadius*2)
