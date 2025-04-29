class_name KillFeed extends Control

const MESSAGE = preload("res://1 Player/GUI/message.tscn")
@onready var chat_box: VBoxContainer = $ChatBox

var Player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

@rpc("call_local")
func send_message(killer,killed):
	var message_copy = MESSAGE.instantiate()
	chat_box.add_child(message_copy)
	message_copy.set_data(killer,killed)
	
