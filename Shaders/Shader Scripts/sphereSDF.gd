@tool
extends Node3D
@export var player:CharacterBody3D
@export var cutMesh:Node3D

@export_range(0,2) var noiseSize:float
@export_range(0,5) var noiseSpeed:float
@export_range(0,3) var noiseStrength:float
@export_range(0,20) var sphereRadius:float
@export_range(0,1) var borderSize:float
@export_color_no_alpha var borderColor:Color
@export var followPlayer:bool
@onready var bubble:MeshInstance3D = $Bubble

func _ready() -> void:
	bubble.mesh.set_radius(sphereRadius)
	bubble.mesh.set_height(sphereRadius*2)
	
func _process(_delta: float) -> void:
	if cutMesh != null:
		for objects in cutMesh.get_children():
			if objects is CharacterBody3D:
				for player in objects.get_children():
					if player.get("material_override") != null:
						var shaderMat:ShaderMaterial = player.material_override
						#pass shader the info it needs
						shaderMat.set_shader_parameter("spherePos",global_position)
						shaderMat.set_shader_parameter("sphereRadius",sphereRadius)
						shaderMat.set_shader_parameter("borderSize",borderSize)
						shaderMat.set_shader_parameter("borderColor",borderColor)
						shaderMat.set_shader_parameter("noiseSize",noiseSize)
						shaderMat.set_shader_parameter("noiseSpeed",noiseSpeed)
						shaderMat.set_shader_parameter("noiseStrength",noiseStrength)
			if objects.get("material_override") != null:
				var shaderMat:ShaderMaterial = objects.material_override
				#pass shader the info it needs
				shaderMat.set_shader_parameter("spherePos",global_position)
				shaderMat.set_shader_parameter("sphereRadius",sphereRadius)
				shaderMat.set_shader_parameter("borderSize",borderSize)
				shaderMat.set_shader_parameter("borderColor",borderColor)
				shaderMat.set_shader_parameter("noiseSize",noiseSize)
				shaderMat.set_shader_parameter("noiseSpeed",noiseSpeed)
				shaderMat.set_shader_parameter("noiseStrength",noiseStrength)
	
	bubble.mesh.set_radius(sphereRadius)
	bubble.mesh.set_height(sphereRadius*2)
	
func _physics_process(_delta: float) -> void:
	if followPlayer:
		global_position = player.global_position
