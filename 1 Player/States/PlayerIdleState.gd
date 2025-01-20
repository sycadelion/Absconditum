class_name PlayerIdleState extends PlayerMovementState

@export var SPEED: float = 5.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25

@rpc("call_local")
func Enter():
	PLAYER.anim_tree["parameters/FallAndFloor/transition_request"] = "Idle"

func Update(delta: float):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	#if Input.is_action_just_pressed("crouch") and PLAYER.is_on_floor():
		#pass
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		Transition.emit(self,"PlayerWalkState")
