class_name WeaponManager extends Node

signal Weapon_changed
signal Update_ammo
signal update_weapon_stack

@onready var muzzle_flash: GPUParticles3D = %MuzzleFlash
@onready var ammo_count: Label = $"../CanvasLayer/HUD/Ammo/Ammo_count"
@onready var anim_player: AnimationPlayer = %AnimationPlayer

#HUD ammo counts:
#Not Manual:
@onready var Type_A_Node: Control = $"../CanvasLayer/HUD/AmmoType_A"
@onready var type_A_loaded: Label = $"../CanvasLayer/HUD/AmmoType_A/Loaded"

#Manual:
@onready var Type_M_Node: Control = $"../CanvasLayer/HUD/AmmoType_M"
@onready var Type_M_chambered: Label = $"../CanvasLayer/HUD/AmmoType_M/Chambered"
@onready var Type_M_mag: Label = $"../CanvasLayer/HUD/AmmoType_M/Mag"

#weapon slot 1
@onready var Weapon_Slot1: Label = $"../CanvasLayer/HUD/Weapon1/AmmoCount"
#weapon slot 2 
@onready var Weapon_Slot2: Label = $"../CanvasLayer/HUD/Weapon2/AmmoCount"


var Player: Player
var Current_weapon = null
var Weapon_stack = []
var Weapon_indicator = 0
var Next_Weapon: String

var Weapon_list = {}

var shooting:bool = false

@export var _weapon_resouces: Array[WeaponResource]
@export var Start_weapons: Array[String]

func _ready() -> void:
	Player = owner
	Initialize.rpc(Start_weapons)

func _process(_delta: float) -> void:
	if Current_weapon.Manual:
		Type_M_chambered.text = str(Current_weapon.Chambered_ammo)
		Type_M_mag.text = str(Current_weapon.Current_ammo)
	else:
		type_A_loaded.text = str(Current_weapon.Current_ammo)
	if Weapon_stack[1] != null:
		Weapon_Slot1.text = str(Weapon_list[Weapon_stack[0]].Reserve_ammo)
		Weapon_Slot2.text = str(Weapon_list[Weapon_stack[1]].Reserve_ammo)

func _input(event: InputEvent) -> void:
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	if event.is_action_pressed("Weapon1") and not GameManager.paused: ##Switch to slot 1
		Weapon_indicator = 0
		Exit.rpc(Weapon_stack[Weapon_indicator])
	if event.is_action_pressed("Weapon2") and not GameManager.paused:  ##Switch to slot 2
		Weapon_indicator = 1
		Exit.rpc(Weapon_stack[Weapon_indicator])
	if event.is_action_pressed("shoot") and not shooting and not GameManager.paused:
		if Current_weapon.Manual:
			if Current_weapon.Chambered_ammo == 1:
				shoot_manual.rpc()
		else:
			if Current_weapon.Current_ammo >0:
				shoot.rpc()
	if event.is_action_pressed("reload") and Current_weapon.Reserve_ammo > 0 \
	 and not GameManager.paused:
		reload.rpc()
	if event.is_action_pressed("altFire"):
		if Current_weapon.Manual:
			if Current_weapon.Chambered_ammo <= 0 and Current_weapon.Current_ammo > 0:
				Current_weapon.Current_ammo -= 1
				Current_weapon.Chambered_ammo = 1

@rpc("call_local")
func Initialize(_Start_weapons):
	#create dictionary to refer to weapons
	for weapon in _weapon_resouces:
		Weapon_list[weapon.Weapon_name] = weapon
	
	for i in _Start_weapons:
		Weapon_stack.push_back(i)
	
	Current_weapon = Weapon_list[Weapon_stack[0]]
	Enter.rpc()

@rpc("call_local")
func Enter():
	if Current_weapon.Anim_activate:
		anim_player.play(Current_weapon.Anim_activate)
		if Current_weapon.Manual:
			Type_A_Node.hide()
			Type_M_Node.show()
			Type_M_chambered.text = str(1)
			Type_M_mag.text = str(Current_weapon.Current_ammo)
		else:
			Type_M_Node.hide()
			Type_A_Node.show()
			type_A_loaded.text = str(Current_weapon.Current_ammo)

@rpc("call_local")
func Change_Weapon(weapon_name: String):
	Current_weapon = Weapon_list[weapon_name]
	Next_Weapon = ""        
	Enter.rpc()

@rpc("call_local")
func Exit(_next_weapon: String):
	if _next_weapon != Current_weapon.Weapon_name:	
		if Current_weapon.Anim_deactivate:
			anim_player.play(Current_weapon.Anim_deactivate)
			Next_Weapon = _next_weapon


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == Current_weapon.Anim_deactivate:
		Change_Weapon.rpc(Next_Weapon)
	if anim_name == Current_weapon.Anim_reload:
		var reload_amount = Current_weapon.Reload_ammo - Current_weapon.Current_ammo
		if Current_weapon.Reserve_ammo - reload_amount > 0:
			Current_weapon.Current_ammo += reload_amount
			Current_weapon.Reserve_ammo -= reload_amount
		else:
			Current_weapon.Current_ammo += Current_weapon.Reserve_ammo
			Current_weapon.Reserve_ammo = 0

@rpc("call_local")
func shoot():
	shooting = true
	Player.anim_tree["parameters/Shooting/transition_request"] = "True"
	Player.audio_comp.Play_bow()
	Player.bullet_proj_comp.bulletFire()
	muzzle_flash.restart()
	muzzle_flash.emitting = true
	Current_weapon.Current_ammo -= 1
	await get_tree().create_timer(Current_weapon.Firerate).timeout
	shooting = false

@rpc("call_local")
func shoot_manual():
	shooting = true
	Player.anim_tree["parameters/Shooting/transition_request"] = "True"
	Player.audio_comp.Play_bow()
	Player.bullet_proj_comp.bulletFire()
	muzzle_flash.restart()
	muzzle_flash.emitting = true
	Current_weapon.Chambered_ammo -= 1
	await get_tree().create_timer(Current_weapon.Firerate).timeout
	shooting = false

@rpc("call_local")
func reload():
	anim_player.play(Current_weapon.Anim_reload)
