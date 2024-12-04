extends Node3D
class_name BulletTrail

var max_distance: float
var _trail_mesh_height: float
var playerID: int
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
	if body.is_in_group("Players"):
		var feed = get_tree().get_first_node_in_group("Killfeed")
		var hit_player = Lobby.players[body.owner_id].name
		var owner_id = Lobby.players[playerID].name
		feed.send_message(owner_id,hit_player)
		Lobby.players[body.owner_id].deaths += 1
		body.receive_damage.rpc_id(body.get_multiplayer_authority())
		Lobby.players[playerID].kills += 1
		queue_free()
	elif body != null and not body.is_in_group("Players"):
		queue_free()
