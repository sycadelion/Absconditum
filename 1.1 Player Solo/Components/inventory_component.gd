extends Node

signal inventoryToggle

@onready var player_inventory: Control = $PlayerInventory
@onready var loot_inventory: Control = $LootInventory

var item_held = null
var open = false

func _ready() -> void:
	inventoryToggle.connect(visibleToggle)

func _process(_delta: float) -> void:
	pass

func visibleToggle():
	player_inventory.visible = !player_inventory.visible
	loot_inventory.visible = !loot_inventory.visible
