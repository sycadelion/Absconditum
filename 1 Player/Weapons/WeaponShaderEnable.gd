extends Node3D

@export var EnableShader: bool = true
@export var object1: MeshInstance3D
@export var object2: MeshInstance3D

func _ready() -> void:
	var ShaderMat1:ShaderMaterial = object1.material_override
	ShaderMat1.set_shader_parameter("enabled", EnableShader)
	if object2:
		var ShaderMat2:ShaderMaterial = object2.material_override
		ShaderMat2.set_shader_parameter("enabled", EnableShader)
		return

func _process(_delta: float) -> void:
	var ShaderMat1:ShaderMaterial = object1.material_override
	ShaderMat1.set_shader_parameter("enabled", EnableShader)
	if object2:
		var ShaderMat2:ShaderMaterial = object2.material_override
		ShaderMat2.set_shader_parameter("enabled", EnableShader)
		return
