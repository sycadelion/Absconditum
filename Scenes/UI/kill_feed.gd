extends Control

const MESSAGE = preload("res://Scenes/UI/message.tscn")
@onready var chat_box: VBoxContainer = $ChatBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func send_message(killer,kille):
	var message_copy = MESSAGE.instantiate()
	chat_box.add_child(message_copy)
	message_copy.set_data(killer,kille)
	
