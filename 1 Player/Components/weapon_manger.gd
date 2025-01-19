class_name WeaponManager extends Node

signal Weapon_changed
signal Update_ammo
signal update_weapon_stack

@onready var muzzle_flash: GPUParticles3D = %MuzzleFlash
@onready var ammo_count: Label = $"../CanvasLayer/HUD/Ammo/Ammo_count"
@onready var anim_player: AnimationPlayer = %AnimationPlayer

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
	if Current_weapon:
		ammo_count.text = str(Current_weapon.Current_ammo) + " / " + str(Current_weapon.Reserve_ammo)

func _input(event: InputEvent) -> void:
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	if event.is_action_pressed("Weapon1") and not GameManager.paused: ##Switch to slot 1
		Weapon_indicator = 0
		Exit.rpc(Weapon_stack[Weapon_indicator])
	if event.is_action_pressed("Weapon2") and not GameManager.paused:  ##Switch to slot 2
		Weapon_indicator = 1
		Exit.rpc(Weapon_stack[Weapon_indicator])
	if event.is_action_pressed("shoot") and not shooting \
	 and not GameManager.paused and Current_weapon.Current_ammo >0:
		shoot.rpc()
	if event.is_action_pressed("reload") and not GameManager.paused:
		reload.rpc()

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
		ammo_count.text = str(Current_weapon.Current_ammo) + " / " + str(Current_weapon.Reserve_ammo)

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
	if anim_name == Current_weapon.Anim_shoot:
		shooting = false
	if anim_name == Current_weapon.Anim_reload:
		Current_weapon.Current_ammo = Current_weapon.Reload_ammo
		Current_weapon.Reserve_ammo -= Current_weapon.Reload_ammo

@rpc("call_local")
func shoot():
	shooting = true
	anim_player.play(Current_weapon.Anim_shoot)
	Player.audio_comp.Play_bow()
	Player.bullet_proj_comp.bulletFire()
	muzzle_flash.restart()
	muzzle_flash.emitting = true
	Current_weapon.Current_ammo -= 1

@rpc("call_local")
func reload():
	anim_player.play(Current_weapon.Anim_reload)
