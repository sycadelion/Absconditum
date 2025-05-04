extends Control

@onready var grid_container = %GridContainer
@onready var slot_scene = preload("uid://vd8l2hqpwx0v")
@onready var item_scene = preload("uid://byh855t5dnkc0")
@onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
@onready var col_count = grid_container.columns

@export var slots: int

var grid_array := []
var item_held = null
var current_slot = null
var can_place = false
var icon_anchor: Vector2

var inven_compo

func _ready() -> void:
	inven_compo = get_parent()
	for i in range(slots):
		create_slot()

func _process(delta: float) -> void:
	if inven_compo.item_held:
		if Input.is_action_just_pressed("rotate_item"):
			rotate_item()
		if Input.is_action_just_pressed("shoot"):
			if scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				place_item()
	else:
		if Input.is_action_just_pressed("shoot"):
			if scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				pick_item()

func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_id = grid_array.size()
	grid_array.push_back(new_slot)
	grid_container.add_child(new_slot)
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)

func _on_slot_mouse_entered(a_Slot):
	icon_anchor = Vector2(10000,100000)
	current_slot = a_Slot
	if inven_compo.item_held:
		check_slot_availability(current_slot)
		set_grids.call_deferred(current_slot)

func _on_slot_mouse_exited(a_Slot):
	clear_grid()
	
	if not grid_container.get_global_rect().has_point(get_global_mouse_position()):
		current_slot = null

func _on_button_spawn_pressed() -> void:
	var new_item = item_scene.instantiate()
	inven_compo.add_child(new_item)
	new_item.load_item(randi_range(1,4))
	new_item.selected = true
	inven_compo.item_held = new_item

func check_slot_availability(a_slot) -> void:
	for grid in inven_compo.item_held.item_grids:
		var grid_to_check = a_slot.slot_id + grid[0] + grid[1] * col_count
		var line_switch_check = a_slot.slot_id % col_count + grid[0]
		if line_switch_check < 0 or line_switch_check >= col_count:
			can_place = false
			return
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			can_place = false
			return
		if grid_array[grid_to_check].state == grid_array[grid_to_check].States.TAKEN:
			can_place = false
			return
		
	can_place = true

func set_grids(a_slot) -> void:
	for grid in inven_compo.item_held.item_grids:
		var grid_to_check = a_slot.slot_id + grid[0] + grid[1] * col_count 
		var line_switch_check = a_slot.slot_id % col_count + grid[0]
		
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			continue
		if line_switch_check < 0 or line_switch_check >= col_count:
			continue
		
		if can_place:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.FREE)
			
			if grid[1] < icon_anchor.x: icon_anchor.x = grid[1]
			if grid[0] < icon_anchor.y: icon_anchor.y = grid[0]
		else:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.TAKEN)

func clear_grid():
	for grid in grid_array:
		grid.set_color(grid.States.DEFAULT)

func rotate_item():
	inven_compo.item_held.rotate_item()
	clear_grid()
	if current_slot:
		_on_slot_mouse_entered(current_slot)

func place_item():
	if not can_place or not current_slot:
		return #place cues here to show can't place
	
	var calculated_grid_id = current_slot.slot_id + icon_anchor.x * col_count + icon_anchor.y
	inven_compo.item_held._snap_to(grid_array[calculated_grid_id].global_position)
	inven_compo.item_held.get_parent().remove_child(inven_compo.item_held)
	grid_container.add_child(inven_compo.item_held)
	inven_compo.item_held.global_position = get_global_mouse_position()
	
	inven_compo.item_held.grid_anchor = current_slot
	for grid in inven_compo.item_held.item_grids:
		var grid_to_check = current_slot.slot_id + grid[0] + grid[1] * col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.TAKEN
		grid_array[grid_to_check].item_stored = inven_compo.item_held
		
	inven_compo.item_held = null
	clear_grid()

func pick_item():
	if not current_slot or not current_slot.item_stored: 
		return

	inven_compo.item_held = current_slot.item_stored
	inven_compo.item_held.selected = true
	#move node in the scene tree
	inven_compo.item_held.get_parent().remove_child(inven_compo.item_held)
	inven_compo.add_child(inven_compo.item_held)
	inven_compo.item_held.global_position = get_global_mouse_position()
	
	for grid in inven_compo.item_held.item_grids:
		var grid_to_check = inven_compo.item_held.grid_anchor.slot_id + grid[0] + grid[1] * col_count # use grid anchor instead of current slot to prevent bug
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.FREE 
		grid_array[grid_to_check].item_stored = null
	
	check_slot_availability(current_slot)
	set_grids.call_deferred(current_slot)
