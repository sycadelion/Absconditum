class_name PlayerSoloRunState extends PlayerSoloMovementState

@export var SPEED_MULTI: float = 6.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25

@rpc("call_local")
func Enter():
	PLAYER.anim_tree["parameters/FallAndFloor/transition_request"] = "Move"
	SPEED_MULTI = OnlineMang.onlineComp.matchSettings.player_sprint

func Update(delta: float):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(PLAYER.SPEED * SPEED_MULTI,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_released("sprint"):
		Transition.emit(self, "PlayerWalkState")
	#if Input.is_action_just_pressed("sprint") and PLAYER.is_on_floor() and not GameManager.paused:
		#Transition.emit("PlayerWalkState", "PlayerRunState")
	#if Input.is_action_just_pressed("crouch") and PLAYER.is_on_floor() and not GameManager.paused:
		#pass
	if PLAYER.velocity.length() == 0.0 and PLAYER.is_on_floor() and not GameManager.paused:
		Transition.emit(self, "PlayerIdleState")

func Exit():
	pass
