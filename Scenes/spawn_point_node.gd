extends Node3D

@export var SpawnActive:bool = true
@export var SpawnPOS: Vector3
@onready var marker: Marker3D = $Marker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpawnPOS = marker.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Players"):
		SpawnActive = false

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Players"):
		SpawnActive = true
