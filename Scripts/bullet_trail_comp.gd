extends Node3D

@export var _bullet_trail_prefab: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func bulletFire(camera,marker,playerID) ->void:
	var bullet_trail:BulletTrail = _bullet_trail_prefab.instantiate()
	marker.add_child(bullet_trail)
	bullet_trail.playerID = playerID
	bullet_trail.global_position = marker.global_position
	var look_at_point: Vector3 = camera.global_position + (camera.global_transform.basis.z * 100)
	bullet_trail.look_at(look_at_point,Vector3.UP)
