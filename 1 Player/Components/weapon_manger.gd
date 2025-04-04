class_name WeaponManager extends Node

signal Weapon_changed
signal Update_ammo
signal update_weapon_stack

@onready var muzzle_flash: GPUParticles3D = %MuzzleFlash
@onready var ammo_count: Label = $"../CanvasLayer/HUD/Ammo/Ammo_count"
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var anim_tree: AnimationTree = $"../AnimationTree"

#HUD ammo counts:
#Not Manual:
@onready var Type_A_Node: Control = $"../CanvasLayer/HUD/AmmoType_A"
@onready var type_A_loaded: Label = $"../CanvasLayer/HUD/AmmoType_A/Loaded"

#Manual:
@onready var Type_M_Node: Control = $"../CanvasLayer/HUD/AmmoType_M"
@onready var Type_M_chambered: Label = $"../CanvasLayer/HUD/AmmoType_M/Chambered"
@onready var Type_M_mag: Label = $"../CanvasLayer/HUD/AmmoType_M/Mag"

#weapon slot 1
@onready var Weapon_Slot1: Label = $"../CanvasLayer/HUD/WeaponRoot/Weapon1/AmmoCount"
@onready var weapon1_image: TextureRect = $"../CanvasLayer/HUD/WeaponRoot/Weapon1/PanelContainer/weapon1_image"

#weapon slot 2 
@onready var Weapon_Slot2: Label = $"../CanvasLayer/HUD/WeaponRoot/Weapon2/AmmoCount"
@onready var weapon2_image: TextureRect = $"../CanvasLayer/HUD/WeaponRoot/Weapon2/PanelContainer/weapon2_image"



var Player: Player
@export var Current_weapon = {}
@export var Weapon_slot1 = {}
var slot1_texture
@export var Weapon_slot2 = {}
var slot2_texture
@export var Weapon_stack = []
var Weapon_indicator = 0
var Next_Weapon: String



var shooting:bool = false
var can_shoot:bool = false

@export var Start_weapons: Array[String]

func _ready() -> void:
	Player = owner
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	Initialize.rpc(Start_weapons)

func _process(_delta: float) -> void:
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	if Current_weapon.Manual:
		Type_M_chambered.text = str(Current_weapon.Chambered_ammo)
		Type_M_mag.text = str(Current_weapon.Current_ammo)
	else:
		type_A_loaded.text = str(Current_weapon.Current_ammo)
	if Weapon_stack[1] != null:
		Weapon_Slot1.text = str(OnlineMang.onlineComp.weaponList[Weapon_stack[0]].Reserve_ammo)
		weapon1_image.texture = slot1_texture
		Weapon_Slot2.text = str(OnlineMang.onlineComp.weaponList[Weapon_stack[1]].Reserve_ammo)
		weapon2_image.texture = slot2_texture

func _input(event: InputEvent) -> void:
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	if event.is_action_pressed("Weapon1") and not shooting and not GameManager.paused: ##Switch to slot 1
		Weapon_indicator = 0
		Exit.rpc(Weapon_stack[Weapon_indicator])
	if event.is_action_pressed("Weapon2") and not shooting and not GameManager.paused:  ##Switch to slot 2
		Weapon_indicator = 1
		Exit.rpc(Weapon_stack[Weapon_indicator])
	if event.is_action_pressed("shoot") and not shooting and can_shoot and not GameManager.paused:
		if Current_weapon.Manual:
			if Current_weapon.Chambered_ammo == 1:
				shoot_manual.rpc()
			else:
				shoot_empty.rpc()
		else:
			if Current_weapon.Current_ammo >0:
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
		if Current_weapon.Manual:
			if Current_weapon.Chambered_ammo <= 0 and Current_weapon.Current_ammo > 0:
				Player.audio_comp.Play_reload(Current_weapon.Audio_Name,true)
				Current_weapon.Current_ammo -= 1
				Current_weapon.Chambered_ammo = 1

@rpc("any_peer","call_local")
func Initialize(_Start_weapons):
	
	for i in _Start_weapons:
		Weapon_stack.push_back(i)
	
	var slot1_image = Image.load_from_file(OnlineMang.onlineComp.weaponList[Weapon_stack[0]].Weapon_Image_Path)
	slot1_texture = ImageTexture.create_from_image(slot1_image)
	var slot2_image = Image.load_from_file(OnlineMang.onlineComp.weaponList[Weapon_stack[1]].Weapon_Image_Path)
	slot2_texture = ImageTexture.create_from_image(slot2_image)
	Current_weapon = OnlineMang.onlineComp.weaponList[Weapon_stack[0]]
	Enter.rpc()

@rpc("any_peer","call_local")
func Enter():
	if Current_weapon.Anim_activate:
		anim_tree["parameters/Equip/transition_request"] = Current_weapon.Weapon_name
		if Current_weapon.Manual:
			Type_A_Node.hide()
			Type_M_Node.show()
			Type_M_chambered.text = str(1)
			Type_M_mag.text = str(Current_weapon.Current_ammo)
			can_shoot = true
		else:
			Type_M_Node.hide()
			Type_A_Node.show()
			type_A_loaded.text = str(Current_weapon.Current_ammo)
			can_shoot = true

@rpc("any_peer","call_local")
func Change_Weapon(_weapon_name: String):
	if Weapon_indicator == 0:
		Current_weapon = OnlineMang.onlineComp.weaponList[Weapon_stack[0]]
	elif Weapon_indicator == 1:
		Current_weapon = OnlineMang.onlineComp.weaponList[Weapon_stack[1]]
	#set_Weaponslot(Current_weapon,OnlineMang.onlineComp.weaponList[weapon_name])
	Next_Weapon = ""        
	Enter.rpc()

@rpc("any_peer","call_local")
func Exit(_next_weapon: String):
	if _next_weapon != Current_weapon.Weapon_name:	
		if Current_weapon.Anim_deactivate:
			can_shoot = false
			anim_player.play(Current_weapon.Anim_deactivate)
			Next_Weapon = _next_weapon


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == Current_weapon.Anim_deactivate:
		Change_Weapon.rpc(Next_Weapon)
	if anim_name == Current_weapon.Anim_activate:
		can_shoot = true
	if anim_name == Current_weapon.Anim_shoot and Current_weapon.Full_auto:
		if Input.is_action_pressed("shoot") and Current_weapon.Current_ammo > 0:
			shoot.rpc()
	if anim_name == Current_weapon.Anim_reload:
		if Player.owner_id != multiplayer.get_unique_id(): 
			return
		if not Current_weapon.Manual:
			var reload_amount = Current_weapon.Reload_ammo - Current_weapon.Current_ammo
			if Current_weapon.Reserve_ammo - reload_amount > 0:
				Current_weapon.Current_ammo += reload_amount
				Current_weapon.Reserve_ammo -= reload_amount
			else:
				Current_weapon.Current_ammo += Current_weapon.Reserve_ammo
				Current_weapon.Reserve_ammo = 0
		else:
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
	Player.audio_comp.Play_ammo(Current_weapon.Audio_Name)
	Player.bullet_proj_comp.bulletFire(Current_weapon.Damage)
	muzzle_flash.restart()
	muzzle_flash.emitting = true
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	Current_weapon.Current_ammo -= 1
	await get_tree().create_timer(Current_weapon.Firerate).timeout
	shooting = false

@rpc("any_peer","call_local")
func shoot_manual():
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
	Current_weapon.Reserve_ammo = Current_weapon.Max_reserve

@rpc("call_local")
func respawn_ammo():
	if Player.owner_id != multiplayer.get_unique_id(): 
		return
	OnlineMang.onlineComp.weaponList[Weapon_stack[0]].Current_ammo = OnlineMang.onlineComp.weaponList[Weapon_stack[0]].Reload_ammo
	OnlineMang.onlineComp.weaponList[Weapon_stack[0]].Reserve_ammo = OnlineMang.onlineComp.weaponList[Weapon_stack[0]].Max_reserve
	OnlineMang.onlineComp.weaponList[Weapon_stack[0]].Chambered_ammo = OnlineMang.onlineComp.weaponList[Weapon_stack[0]].Max_Chambered_ammo
	OnlineMang.onlineComp.weaponList[Weapon_stack[1]].Current_ammo = OnlineMang.onlineComp.weaponList[Weapon_stack[1]].Reload_ammo
	OnlineMang.onlineComp.weaponList[Weapon_stack[1]].Reserve_ammo = OnlineMang.onlineComp.weaponList[Weapon_stack[1]].Max_reserve
	OnlineMang.onlineComp.weaponList[Weapon_stack[1]].Chambered_ammo = OnlineMang.onlineComp.weaponList[Weapon_stack[1]].Max_Chambered_ammo

func set_Weaponslot(weaponSlot,weaponRes):
	weaponSlot.Weapon_name = weaponRes.Weapon_name
	weaponSlot.Anim_activate = weaponRes.Anim_activate
	weaponSlot.Anim_shoot = weaponRes.Anim_shoot
	weaponSlot.Anim_empty = weaponRes.Anim_empty
	weaponSlot.Anim_reload = weaponRes.Anim_reload
	weaponSlot.Anim_deactivate = weaponRes.Anim_deactivate
	weaponSlot.Audio_Name = weaponRes.Audio_Name
	weaponSlot.Weapon_Image_Path = weaponRes.Weapon_Image_Path
	weaponSlot.Damage = weaponRes.Damage
	weaponSlot.Current_ammo = weaponRes.Current_ammo
	weaponSlot.Reload_ammo = weaponRes.Reload_ammo
	weaponSlot.Reserve_ammo = weaponRes.Reserve_ammo
	weaponSlot.Max_reserve = weaponRes.Max_reserve
	weaponSlot.Chambered_ammo = weaponRes.Chambered_ammo
	weaponSlot.Max_Chambered_ammo = weaponRes.Max_Chambered_ammo
	weaponSlot.Full_auto = weaponRes.Full_auto
	weaponSlot.Manual = weaponRes.Manual
	weaponSlot.Launcher = weaponRes.Launcher
	weaponSlot.Firerate = weaponRes.Firerate
