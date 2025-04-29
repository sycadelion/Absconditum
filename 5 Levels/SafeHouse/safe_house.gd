extends Node3D

var enviro:Environment

func _ready() -> void:
	enviro = $SubViewportContainer/SubViewport/WorldEnvironment.environment

func _process(_delta: float) -> void:
	if SettingsManager.ChosenPalette:
		enviro.adjustment_color_correction = SettingsManager.ChosenPalette
