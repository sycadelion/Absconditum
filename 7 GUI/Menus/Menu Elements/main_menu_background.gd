extends Node3D

var enviro:Environment

func _ready() -> void:
	enviro = $SubViewportContainer/SubViewport/WorldEnvironment.environment

func _process(delta: float) -> void:
	if GameManager.palette:
		enviro.adjustment_color_correction = GameManager.palette
