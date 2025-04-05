class_name WeaponManager extends Node

signal Weapon_changed
signal Update_ammo
signal update_weapon_stack

@onready var muzzle_flash: GPUParticles3D = %MuzzleFlash
@onready var ammo_count: Label = $"../CanvasLayer/HUD/Ammo/Ammo_count"
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var anim_tree: AnimationTree = $"../AnimationTree"

#HUD ammo counts:
#Manual:
@onready var Type_M_Node: Control = $"../CanvasLayer/HUD/AmmoType_M"
@onready var Type_M_chambered: Label = $"../CanvasLayer/HUD/AmmoType_M/Chambered"
@onready var Type_M_mag: Label = $"../CanvasLayer/HUD/AmmoType_M/Mag"

#weapon slot 1
@onready var Weapon_Slot1: Label = $"../CanvasLayer/HUD/WeaponRoot/Weapon1/AmmoCount"
@onready var weapon1_image: TextureRect = $"../CanvasLayer/HUD/WeaponRoot/Weapon1/PanelContainer/weapon1_image"

var Player: Player
@export var Current_weapon: Dictionary



var shooting:bool = false
var can_shoot:bool = false


func _ready() -> void:
	Player = owner
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	Current_weapon = OnlineMang.onlineComp.weaponList["Malice"]
	can_shoot = true

func _process(_delta: float) -> void:
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	
	Type_M_chambered.text = str(Current_weapon.Chambered_ammo)
	Type_M_mag.text = str(Current_weapon.Current_ammo)
	
	Weapon_Slot1.text = str(OnlineMang.onlineComp.weaponList["Malice"].Reserve_ammo)

func _input(event: InputEvent) -> void:
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	if event.is_action_pressed("shoot") and not shooting and can_shoot and not GameManager.paused:
		if Current_weapon.Manual:
			if Current_weapon.Chambered_ammo == 1:
				shoot.rpc()
			else:
				shoot_empty.rpc()
	if event.is_action_pressed("reload") and Current_weapon.Reserve_ammo >= 1 \
	 and not GameManager.paused and Current_weapon.Current_ammo < Current_weapon.Reload_ammo:
		reload.rpc()
		Current_weapon.Reserve_ammo -= 1
		Current_weapon.Current_ammo += 1
	if Input.is_action_pressed("reload") and Current_weapon.Reserve_ammo <= 0 \
	and not GameManager.paused:
		shoot_empty.rpc()
	if event.is_action_pressed("altFire"):
		if Current_weapon.Chambered_ammo <= 0 and Current_weapon.Current_ammo > 0:
			can_shoot = false
			Player.audio_comp.Play_reload(Current_weapon.Audio_Name,true)
			Current_weapon.Current_ammo -= 1
			Current_weapon.Chambered_ammo = 1
			can_shoot = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == Current_weapon.Anim_reload:
		if Player.owner_id != multiplayer.get_unique_id(): 
			return
		if Input.is_action_pressed("reload") and Current_weapon.Reserve_ammo >= 1 \
		and not GameManager.paused and Current_weapon.Current_ammo < Current_weapon.Reload_ammo:
			reload.rpc()
			Current_weapon.Reserve_ammo -= 1
			Current_weapon.Current_ammo += 1
		elif Input.is_action_pressed("reload") and Current_weapon.Reserve_ammo <= 0 \
		and not GameManager.paused:
			shoot_empty.rpc()

@rpc("any_peer","call_local")
func shoot():
	shooting = true
	Player.anim_tree["parameters/Shooting/transition_request"] = "True"
	Player.audio_comp.Play_shoot(Current_weapon.Audio_Name)
	Player.bullet_proj_comp.bulletFire.rpc(Current_weapon.Damage)
	muzzle_flash.restart()
	muzzle_flash.emitting = true
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	Current_weapon.Chambered_ammo -= 1
	await get_tree().create_timer(Current_weapon.Firerate).timeout
	shooting = false

@rpc("any_peer","call_local")
func shoot_empty():
	shooting = true
	Player.anim_tree["parameters/DryFire/transition_request"] = "True"
	await get_tree().create_timer(.01).timeout
	shooting = false

@rpc("any_peer","call_local")
func reload():
	Player.audio_comp.Play_reload(Current_weapon.Audio_Name,false)
	anim_player.play(Current_weapon.Anim_reload)

@rpc("call_local")
func refill_ammo():
	if Current_weapon.Current_ammo > 0:
		Current_weapon.Reserve_ammo = Current_weapon.Max_reserve
	else:
		Current_weapon.Reserve_ammo = Current_weapon.Max_reserve + Current_weapon.Reload_ammo + 1

@rpc("any_peer","call_local")
func respawn_ammo():
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	OnlineMang.onlineComp.weaponList["Malice"].Current_ammo = OnlineMang.onlineComp.weaponList["Malice"].Reload_ammo
	OnlineMang.onlineComp.weaponList["Malice"].Reserve_ammo = OnlineMang.onlineComp.weaponList["Malice"].Max_reserve
	OnlineMang.onlineComp.weaponList["Malice"].Chambered_ammo = OnlineMang.onlineComp.weaponList["Malice"].Max_Chambered_ammo
