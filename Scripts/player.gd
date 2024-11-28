extends CharacterBody3D

@export var player_id := 1
@export var health = 1


@onready var camera: Camera3D = $Camera3D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle_flash: GPUParticles3D = $Camera3D/MuzzleFlash
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var bodyInvert: MeshInstance3D = $Player_Body2
@onready var bowViewmodel: Node3D = $Camera3D/bow_viewmodel
@onready var bow: Node3D = $Camera3D/bow
@onready var hud: Control = $CanvasLayer/HUD
@onready var skill1: Control = $CanvasLayer/HUD/Skill
@onready var marker: Marker3D = $Camera3D/Marker3D
@onready var bullet_trail_comp: Node3D = $BulletTrailComp

var sens:float = .005

var owner_id = 1

const SPEED = 5.0
const JUMP_VELOCITY = 5

func _enter_tree() -> void:
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)

func _ready() -> void:
	if owner_id == multiplayer.get_unique_id():
		camera.make_current()
		bowViewmodel.visible = true
		bow.visible = false
		bodyInvert.visible = false
		hud.visible = true
	else:
		camera.current = false
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	if event is InputEventMouseMotion and health >= 1:
		rotate_y(-event.relative.x * sens)
		camera.rotate_x(-event.relative.y * sens)
		camera.rotation.x = clamp(camera.rotation.x,-PI/2, PI/2)
		
	if Input.is_action_just_pressed("shoot") and anim_player.current_animation != "shoot":
		play_shoot_effects.rpc()
		if raycast.is_colliding():
			var hit_player = raycast.get_collider()
			hit_player.receive_damage.rpc_id(hit_player.get_multiplayer_authority())
	if Input.is_action_just_pressed("Skill1"):
		skill1.used_skill()
		
func _physics_process(delta: float) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and health >= 1:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and health >= 1:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	elif health >= 1:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if anim_player.current_animation == "shoot":
		pass
	if anim_player.current_animation == "death":
		pass
	elif input_dir != Vector2.ZERO and is_on_floor():
		anim_player.play("move")
	else:
		anim_player.play("idle")
	move_and_slide()

@rpc("call_local")
func play_shoot_effects():
	anim_player.stop()
	anim_player.play("shoot")
	
	bullet_trail_comp.bulletFire(camera,marker)
	
	muzzle_flash.restart()
	muzzle_flash.emitting = true

@rpc("any_peer")
func receive_damage():
	health -= 1
	if health <= 0:
		health = 1
		position = Vector3.ZERO

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		anim_player.play("idle")
	elif  anim_name == "death":
		health = 1
		anim_player.play("idle")
		position = Vector3.ZERO +Vector3(0,1,0)
