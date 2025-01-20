extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
var slot = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Weapon1") and slot != 1:
		anim_player.play_backwards("Swap")
		slot = 1
	elif event.is_action_pressed("Weapon2") and slot != 2:
		anim_player.play("Swap")
		slot = 2
