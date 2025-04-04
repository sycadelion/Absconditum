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
@onready var ray: RayCast3D = $MeshInstance3D/RayCast3D


@onready var wall_particles: GPUParticles3D = $"MeshInstance3D/Wall hit particles"
@onready var player_particles: GPUParticles3D = $"MeshInstance3D/Player hit particles"

var body
var testNum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bullet_mesh_height = _bullet_mesh.mesh.height
	
	if max_distance == 0:
		await get_tree().create_timer(_bullet_life_time).timeout
		queue_free()

func _process(_delta: float) -> void:
	if hit:
		hit = false
		$Timer.start()

func _physics_process(delta: float) -> void:
	position += velocity * delta
	if ray:
		if ray.is_colliding() and !hit:
			ray.enabled = false
			ray.set_collision_mask_value(2,false)
			ray.set_collision_mask_value(1,true)
			hit = true
			bolt.visible = false
			if ray.get_collider().is_in_group("Players"):
				body = ray.get_collider()
				ray.queue_free()

func set_velocity(target):
	look_at(target)
	velocity = position.direction_to(target) * _bullet_speed

func _on_timer_timeout() -> void:
	if body:
		player_particles.emitting = true
		var playerBody
		playerBody = body.get_parent()
		playerBody.health_comp.receive_damage(_bullet_dmg,playerID)
		queue_free()
	else:
		wall_particles.emitting = true
		queue_free()
