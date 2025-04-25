extends Node3D

@export var HealthDrop: bool = false
@export var materialName: String = "Lino"
@export var respawnTime: float = 30
@onready var ammo_icon: Sprite3D = $AmmoIcon
@onready var health_icon: Sprite3D = $HealthIcon
@export var Spawned: bool = true
@onready var pickup_audio: AkEvent3D = $pickup_Audio


func _ready() -> void:
	$collisionMesh/StaticBody3D.materialName = materialName
	if HealthDrop:
		ammo_icon.hide()
		health_icon.show()
	else:
		health_icon.hide()
		ammo_icon.show()

func _physics_process(_delta: float) -> void:
	if Spawned:
		ammo_icon.show()
	else:
		ammo_icon.hide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if Spawned:
		if body.is_in_group("Players"):
			if HealthDrop:
				if body.health_comp.health != body.health_comp.MAX_HEALTH:
					health_icon.hide()
					body.health_comp.Heal_self()
					play_audio.rpc()
					Spawned = false
			else:
				if body.weapon_manger.Current_weapon.Reserve_ammo != body.weapon_manger.Current_weapon.Max_reserve:
					ammo_icon.hide()
					body.weapon_manger.refill_ammo.rpc()
					play_audio()
					Spawned = false


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Players"):
		$Timer.start(respawnTime)


func _on_timer_timeout() -> void:
	if HealthDrop:
		ammo_icon.hide()
		health_icon.show()
		Spawned = true
	else:
		health_icon.hide()
		ammo_icon.show()
		Spawned = true

@rpc("any_peer","call_local")
func play_audio():
	pickup_audio.post_event()
