class_name Player extends CharacterBody3D


@export var player_id := 1
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 5

#components
@onready var audio_comp: AudioComp = %Audio_Component
@onready var skill1_comp: Skill1Comp = %Skill1_Component
@onready var health_comp: HealthComp = %Health_Component
@onready var bullet_proj_comp: BulletProjComp = %BulletProjComp
@onready var weapon_manger: WeaponManager = %WeaponManger
@onready var state_machine: StateMachine = %StateMachine

@onready var camera: Camera3D = $Camera3D
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var bodyInvert: MeshInstance3D = $Player_Body2
@onready var hud: Control = $CanvasLayer/HUD
@onready var pause: Control = $CanvasLayer/Pause
@onready var killfeed: KillFeed = %KillFeed

#jump vars for landing audio
var landing: bool = false
var impact_played: bool = false

var sens:float = GameManager.sensitivity
var owner_id = 1
var User_name:String
var shooting:bool = false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _enter_tree() -> void:
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)

func _ready() -> void:
	if owner_id == multiplayer.get_unique_id():
		camera.make_current()
		bodyInvert.visible = false
		hud.visible = true
		SPEED = GameManager.player_Speed
		JUMP_VELOCITY = GameManager.player_jump
		User_name = Lobby.players[owner_id].name
		$Camera3D/crossbow_viewmodel.show()
		FmodServer.add_listener(0,camera) #adds fmod listening
		GameManager.PLAYER = self
	else:
		camera.current = false
		$Camera3D/crossbow_shader.show()
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	if event is InputEventMouseMotion and health_comp.health >= 1:
		rotate_y(-event.relative.x * sens)
		camera.rotate_x(-event.relative.y * sens)
		camera.rotation.x = clamp(camera.rotation.x,-PI/2, PI/2)

func _input(event: InputEvent) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	if event.is_action_pressed("Skill1") and not GameManager.paused:
		skill1_comp.Use_skill.rpc()
	elif event.is_action_pressed("shoot") and not shooting and not GameManager.paused:
		pass
	elif event.is_action_pressed("quit") and not GameManager.paused:
		pause.pause(owner_id)
	elif event.is_action_pressed("reload"):
		weapon_manger.reload.rpc()
	elif event.is_action_pressed("test"):
		print(str(owner_id))

func _physics_process(delta: float) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	sens = GameManager.sensitivity
	
	if is_on_floor():
		if landing and !impact_played:
			audio_comp.Play_land.rpc()
			landing= false
			impact_played = true
	else:
		if !landing:
			landing = true
	
	if velocity.y > 0:
		impact_played = false
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and health_comp.health >= 1 and not GameManager.paused:
		velocity.y = JUMP_VELOCITY
		
	if anim_player.current_animation == "shoot":
		pass
	elif anim_player.current_animation == "death":
		pass
	elif anim_player.current_animation == "Reloading":
		pass
	elif anim_player.current_animation == "Gun_empty":
		pass

func update_input(speed: float, acceleration: float, deceleration: float) ->void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

func update_gravity(delta: float) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	velocity.y -= gravity * delta


func update_velocity() -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if  anim_name == "death":
		health_comp.health = 1
		health_comp.respawn_self.rpc()
	elif  anim_name == "move":
		anim_player.play("idle")
