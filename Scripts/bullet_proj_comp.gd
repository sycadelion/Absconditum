extends Node3D

@export var _bullet_proj_prefab: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func bulletFire(raycast:RayCast3D,marker,markerEnd,playerID) ->void:
	var bullet_proj:BulletProj = _bullet_proj_prefab.instantiate()
	marker.add_child(bullet_proj)
	bullet_proj.playerID = playerID
	bullet_proj.global_position = marker.global_position
	if raycast.is_colliding():
		bullet_proj.set_velocity(raycast.get_collision_point())
	else:
		bullet_proj.set_velocity(markerEnd.global_position)
	
