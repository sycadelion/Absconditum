class_name PlayerSolo extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 5

#components
@onready var audio_comp: AudioCompSolo = $Audio_Component
@export var listener_comp: PackedScene
@onready var skill1_comp: Skill1CompSolo = $Skill1_Component
@onready var health_comp: HealthCompSolo = $Health_Component
@onready var bullet_proj_comp: BulletProjCompSolo = $BulletProjComp
#@onready var weapon_manger: WeaponManagerSolo = $WeaponManger
@onready var state_machine: StateMachine = %StateMachine

@onready var camera: Camera3D = $Head/Camera3D
@onready var head: Node3D = $Head
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var bodyInvert: MeshInstance3D = $Player_Body2
@onready var hud: Control = $CanvasLayer/HUD
@onready var pause: Control = $CanvasLayer/Pause
@onready var inventory: Control = $CanvasLayer/Inventory
@onready var Health_bar: ProgressBar = $CanvasLayer/HUD/HealthBar/PanelContainer/ProgressBar
@onready var Health_Label: Label = $CanvasLayer/HUD/HealthBar/PanelContainer/HealthText

#guns
@onready var hand: Node3D = $Head/Camera3D/Hand


#jump vars for landing audio
var landing: bool = false
var impact_played: bool = false
var floor: bool = true

var sens:float = SettingsManager.MouseSensitivity
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var inventory_open = false



func _ready() -> void:
		Health_bar.max_value = health_comp.MAX_HEALTH
		Health_bar.value = health_comp.health
		Health_Label.text = str(health_comp.health)
		sens = SettingsManager.MouseSensitivity / 1000
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sens)
		head.rotate_x(-event.relative.y * sens)
		head.rotation.x = clamp(head.rotation.x,-PI/2, PI/2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Skill1") and not GameManager.paused:
		skill1_comp.Use_skill.rpc()
	elif event.is_action_pressed("quit") and not GameManager.paused:
		pause.pause()
	elif event.is_action_pressed("reload"):
		pass
		#weapon_manger.reload.rpc()
	elif  event.is_action_pressed("Inventory") and not GameManager.paused:
		if inventory_open:
			inventory_open = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			inventory.hide()
		else:
			inventory_open = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			inventory.show()
	elif event.is_action_pressed("FPS"):
		$CanvasLayer/HUD/Fps.visible = not $CanvasLayer/HUD/Fps.visible
	elif event.is_action_pressed("testAction"):
		pass

func _physics_process(_delta: float) -> void:
	if self.global_position.y <= -15:
		health_comp.receive_damage(health_comp.MAX_HEALTH,-1)
	sens = SettingsManager.MouseSensitivity / 1000
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
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

func update_gravity(delta: float) -> void:
	velocity.y -= gravity * delta


func update_velocity() -> void:
	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if  anim_name == "death":
		health_comp.health = 1
		health_comp.respawn_self.rpc()
	elif  anim_name == "move":
		anim_player.play("idle")
