class_name BulletProj extends Node3D

var max_distance: float
var _bullet_mesh_height: float
var playerID: int
@export var _bullet_mesh: MeshInstance3D
@export var _bullet_life_time: float = 1
@export var _bullet_speed: float = 50
@export var _bullet_dmg: int = 1
var velocity = Vector3.ZERO
var hit = false
@onready var bolt: Node3D = $MeshInstance3D/bolt


@onready var wall_particles: GPUParticles3D = $"MeshInstance3D/Wall hit particles"
@onready var player_particles: GPUParticles3D = $"MeshInstance3D/Player hit particles"

var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bullet_mesh_height = _bullet_mesh.mesh.height
	
	if max_distance == 0:
		await get_tree().create_timer(_bullet_life_time).timeout
		queue_free()
		
func _physics_process(delta: float) -> void:
	position += velocity * delta
	

func _on_rigid_body_3d_body_entered(body: Node) -> void:
	$MeshInstance3D/RigidBody3D.set_collision_layer_value(1,false)
	$MeshInstance3D/RigidBody3D.set_collision_mask_value(2, false)

func set_velocity(target):
	look_at(target)
	velocity = position.direction_to(target) * _bullet_speed


func _on_rigid_body_3d_body_exited(body: Node) -> void:
	if body.is_in_group("Players") and !hit:
		hit = true
		var hit_player = OnlineMang.onlineComp.players[body.owner_id].name
		var owner_id = OnlineMang.onlineComp.players[playerID].name
		
		body.health_comp.receive_damage(_bullet_dmg,playerID)
		
		if body.health_comp.health <=0:
			body.killfeed.send_message(owner_id,hit_player)
		bolt.hide()
		player_particles.emitting = true
		#await get_tree().create_timer(1.0).timeout
		queue_free()
	elif body != null and not body.is_in_group("Players") and !hit:
		bolt.hide()
		wall_particles.emitting = true
		#await get_tree().create_timer(1.0).timeout
		queue_free()
