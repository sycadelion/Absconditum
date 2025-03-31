extends Node3D

@export var HealthDrop: bool = false
@export var materialName: String = "Lino"
@export var respawnTime: float = 30
@onready var ammo_icon: Sprite3D = $AmmoIcon
@onready var health_icon: Sprite3D = $HealthIcon
var Spawned: bool = true


func _ready() -> void:
	$ItemSpawnPoint/StaticBody3D.materialName = materialName
	if HealthDrop:
		ammo_icon.hide()
		health_icon.show()
	else:
		health_icon.hide()
		ammo_icon.show()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Players"):
		if HealthDrop:
			if body.health_comp.health != body.health_comp.MAX_HEALTH and Spawned:
				health_icon.hide()
				body.health_comp.Heal_self.rpc()
				Spawned = false
		else:
			if body.weapon_manger.Current_weapon.Reserve_ammo != body.weapon_manger.Current_weapon.Max_reserve and Spawned:
				ammo_icon.hide()
				body.weapon_manger.refill_ammo.rpc()
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
