extends Control

const MESSAGE = preload("res://Scenes/UI/message.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc("any_peer", "call_local")
func send_message(killer,kille):
	var message_copy = MESSAGE.instantiate()
	
	message_copy.set_data(killer,kille)
