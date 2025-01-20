class_name BulletProjComp extends Node

@export var _bullet_proj_prefab: PackedScene

@onready var raycast: RayCast3D = $"../Head/Camera3D/RayCast3D"
@onready var marker: Marker3D = $"../Head/Camera3D/Marker3D"
@onready var markerEnd: Marker3D = $"../Head/Camera3D/RayCast3D/RaycastEnd"

var Player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = owner

func bulletFire() ->void:
	var bullet_proj:BulletProj = _bullet_proj_prefab.instantiate()
	marker.add_child(bullet_proj)
	bullet_proj.playerID = Player.owner_id
	bullet_proj.global_position = marker.global_position
	if raycast.is_colliding():
		bullet_proj.set_velocity(raycast.get_collision_point())
	else:
		bullet_proj.set_velocity(markerEnd.global_position)
	
