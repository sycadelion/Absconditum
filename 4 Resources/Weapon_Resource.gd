class_name WeaponResource extends Resource

@export var Weapon_name: String

#animations
@export_group("Weapon Animations")
@export var Anim_activate: String ##String name for the animation of bringing out the weapon
@export var Anim_shoot: String ##String name for the animation of shooting
@export var Anim_empty: String ##String name for the animation of being out of loaded ammo
@export var Anim_reload: String ##String name for the animation of reloading
@export var Anim_deactivate: String ##String name for the animation of putting away the weapon

#ammo
@export_group("Ammo")
@export var Current_ammo: int ##Current ammo loaded in the weapon
@export var Reload_ammo: int ##Amount of ammo to be added on reload
@export var Reserve_ammo: int ##Spare unloaded ammo
@export var Max_reserve: int ##Max amount of spare unloaded ammo
@export var Chambered_ammo: int ##The bullets in the chamber


@export_group("Fire Mode")
@export var Full_auto: bool ##Toggle for full auto fire
@export var Manual: bool ##Toggle for needing to chamber each round
@export var Firerate: float ##Rate you can shoot
