extends CharacterBody3D

@onready var pivotNode = $Pivot

# How fast the player moves in meters per second.
@export var lateralSpeed = 9
@export var jetpackSpeed = 5
@export var rotationSpeed = 15
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var motionVelocity = Vector3.ZERO

var direction = Vector3.ZERO
var actions:Array[bool] = [false,false];

var hoverTimeRemaining = 1.0
var groundFallTimeLeft = 0.3

var motionState = "ground"
var motionFuncs = {
	&"ground": groundMotion,
	&"fall": fallMotion,
	&"hover": hoverMotion,
	&"escalate":escalateMotion
}

func groundMotion(delta):
	motionVelocity.x = direction.x * lateralSpeed
	motionVelocity.y = 0;
	motionVelocity.z = direction.z * lateralSpeed
	if is_on_floor() == false:
		groundFallTimeLeft -= delta
		if groundFallTimeLeft < 0:
			groundFallTimeLeft = 0.3
			setState(&"fall")
	else:
		groundFallTimeLeft = 0.3
		

func fallMotion(delta):
	motionVelocity.x = direction.x * jetpackSpeed
	motionVelocity.y = motionVelocity.y - (fall_acceleration * delta)
	motionVelocity.z = direction.z * jetpackSpeed
	if is_on_floor() == true:
		setState(&"ground")


func hoverMotion(delta):
	motionVelocity.x = direction.x * jetpackSpeed
	motionVelocity.y = 0;
	motionVelocity.z = direction.z * jetpackSpeed
	hoverTimeRemaining -= delta
	if hoverTimeRemaining < 0:
		setState(&"fall")
		hoverTimeRemaining = 1.0

func escalateMotion(_delta):
	motionVelocity.x = direction.x * jetpackSpeed
	motionVelocity.y = direction.y * jetpackSpeed
	motionVelocity.z = direction.z * jetpackSpeed
	if is_on_floor() == true and direction.y < 0:
		setState(&"ground")
	elif direction.y == 0:
		setState(&"hover")
	
func setState(nextState:StringName):
	if nextState == motionState:
		#noop
		return

	if nextState == &"escalate" and motionState == &"ground":
		if direction.y < 0:
			#disallowed to go down
			return
		else:
			#extrapop
			position.y += 0.2

	#print(motionState+" "+nextState);
	motionState = nextState;

func _physics_process(delta):
	direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	elif Input.is_action_pressed("move_left"):
		direction.x -= 1

	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	elif Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if Input.is_action_pressed("elevate_up"):
		direction.y += 1
		setState(&"escalate")
	elif Input.is_action_pressed("elevate_down"):
		direction.y -= 1
		setState(&"escalate")

	actions[0] = Input.is_action_pressed("swap")
	actions[1] = Input.is_action_pressed("grab")

	motionFuncs[motionState].call(delta);

	velocity = motionVelocity
	
	if abs(velocity.x) > 0 or abs(velocity.z) > 0:
		var axis = Vector3(0, 1, 0)  # Rotate around the Y-axis
		var angle = atan2(velocity.x, velocity.z)
		#print(velocity)
		#print(angle)
		var my_basis = Basis(axis, angle)
		pivotNode.transform.basis = pivotNode.transform.basis.slerp(my_basis, delta * rotationSpeed).orthonormalized()

	move_and_slide()
