class_name Player extends CharacterBody3D


@export var player_id := 1
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 5

#components
@onready var audio_comp: AudioComp = $Audio_Component
@export var listener_comp: PackedScene
@onready var skill1_comp: Skill1Comp = $Skill1_Component
@onready var health_comp: HealthComp = $Health_Component
@onready var bullet_proj_comp: BulletProjComp = $BulletProjComp
@onready var weapon_manger: WeaponManager = $WeaponManger
@onready var state_machine: StateMachine = %StateMachine

@onready var camera: Camera3D = $Head/Camera3D
@onready var flashlight: SpotLight3D = $Head/Camera3D/Flashlight
@onready var head: Node3D = $Head
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var bodyInvert: MeshInstance3D = $Player_Body2
@onready var hud: Control = $CanvasLayer/HUD
@onready var pause: Control = $CanvasLayer/Pause
@onready var killfeed: KillFeed = %KillFeed
@onready var Health_bar: ProgressBar = $CanvasLayer/HUD/HealthBar/PanelContainer/ProgressBar
@onready var Health_Label: Label = $CanvasLayer/HUD/HealthBar/PanelContainer/HealthText

#guns
@onready var hand: Node3D = $Head/Camera3D/Hand
@onready var hand_2: Node3D = $Head/Camera3D/Hand2


#jump vars for landing audio
var landing: bool = false
var impact_played: bool = false
var floor: bool = true
var playerList

var sens:float = GameManager.sensitivity
var owner_id: int = 1
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var AudioRay: bool = false


func _enter_tree() -> void:
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)

func _ready() -> void:
	if owner_id == multiplayer.get_unique_id():
		var listner_node = listener_comp.instantiate()
		camera.add_child(listner_node)
		GameManager.PLAYER = self
		camera.make_current()
		bodyInvert.visible = false
		flashlight.visible = true
		hud.visible = true
		hand.visible = false
		hand_2.visible = true
		Health_bar.max_value = health_comp.MAX_HEALTH
		Health_bar.value = health_comp.health
		Health_Label.text = str(health_comp.health)
		sens = GameManager.sensitivity / 1000
		SPEED = OnlineMang.onlineComp.matchSettings.player_Speed
		JUMP_VELOCITY = OnlineMang.onlineComp.matchSettings.player_jump
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		camera.current = false
		flashlight.visible = false
		bodyInvert.visible = true
		hand.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sens)
		head.rotate_x(-event.relative.y * sens)
		head.rotation.x = clamp(head.rotation.x,-PI/2, PI/2)

func _input(event: InputEvent) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	if event.is_action_pressed("Skill1") and not GameManager.paused:
		skill1_comp.Use_skill.rpc()
	elif event.is_action_pressed("quit") and not GameManager.paused:
		pause.pause(owner_id)
	elif event.is_action_pressed("reload"):
		weapon_manger.reload.rpc()
	elif event.is_action_pressed("test"):
		$CanvasLayer/HUD/Fps.visible = not $CanvasLayer/HUD/Fps.visible

func _physics_process(_delta: float) -> void:
	if owner_id != multiplayer.get_unique_id(): 
		return
	if self.global_position.y <= -15:
		health_comp.receive_damage(health_comp.MAX_HEALTH,-1)
	sens = GameManager.sensitivity / 1000
	Health_bar.value = health_comp.health
	Health_Label.text = str(health_comp.health)
	
	if is_on_floor():
		floor = true
		if landing and !impact_played:
			audio_comp.Play_land.rpc()
			landing= false
			impact_played = true
	else:
		floor = false
		if !landing:
			landing = true
	
	if velocity.y > 0:
		impact_played = false
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and health_comp.health >= 1 and not GameManager.paused:
		audio_comp.Play_jump.rpc()
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
