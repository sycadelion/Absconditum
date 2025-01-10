class_name WeaponManager extends Node

@onready var muzzle_flash: GPUParticles3D = $"../Camera3D/MuzzleFlash"
@onready var ammo_count: Label = $"../CanvasLayer/HUD/Ammo/Ammo_count"
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

var Player: Player

var ammo_Cap:int = 9
var ammo_mag:int = ammo_Cap
var ammo_clip:int = 0
var need_cocked: bool = false
var is_cocked: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ammo_count.text = str(ammo_mag) + " / " + str(ammo_Cap)

@rpc("call_local")
func shoot():
	if ammo_mag >= 1:
		Player.shooting = true
		ammo_mag -= 1 
		anim_player.stop()
		Player.audio_comp.Play_bow()
		anim_player.play("shoot")
		Player.bullet_proj_comp.bulletFire()
		muzzle_flash.restart()
		muzzle_flash.emitting = true
	else:
		Player.shooting = true
		anim_player.stop()
		anim_player.play("Gun_empty")
		
@rpc("call_local")
func reload():
	if ammo_mag <= 0: 
		Player.shooting = true
		anim_player.play("Reloading")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		Player.shooting = false
		anim_player.play("idle")
	elif  anim_name == "Reloading":
		ammo_mag = ammo_Cap
		Player.shooting = false
		anim_player.play("idle")
	elif  anim_name == "Gun_empty":
		Player.shooting = false
		anim_player.play("idle")
