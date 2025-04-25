extends StaticBody3D

@export var materialName: String ##String for Wwise switch, changes footstep audio

func _ready() -> void:
	if materialName == null:
		materialName = "Lino"
