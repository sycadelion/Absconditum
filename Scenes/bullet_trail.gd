extends Node3D
class_name BulletTrail

var max_distance: float
var _trail_mesh_height: float

@export var _trail_mesh: MeshInstance3D
@export var _bullet_trail_life_time: float = 1
@export var _bullet_trail_speed: float = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_trail_mesh_height = _trail_mesh.mesh.height
	
	if max_distance == 0:
		await get_tree().create_timer(_bullet_trail_life_time).timeout
		queue_free()
		
func _process(delta: float) -> void:
	_trail_mesh.position += Vector3.BACK * _bullet_trail_speed * delta
	
	if max_distance >0 and global_position.distance_to(_trail_mesh.global_position) >= max_distance - (_trail_mesh_height * 2):
		queue_free()
	


func _on_rigid_body_3d_body_entered(body: Node) -> void:
	if body != null:
		queue_free()
