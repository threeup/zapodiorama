extends StaticBody3D

var gameX:int = 0
var gameY:int = 0
var groundY:int = 0
var gameZ:int = 0

var motionState = &"ground"
var motionFuncs = {
	&"ground": groundMotion,
	&"fall": fallMotion,
	&"held": heldMotion
}

var needsAdvance:bool = false

func setGameY(val):
	gameY = val

func setGroundY(val):
	groundY = val

func deduceGroundY(boss):
	groundY = boss.getHeight(gameX,gameZ)

func setGameXZ(x,z):
	gameX = x
	gameZ = z

func shiftGameXZ(x,z):
	gameX += x
	gameZ += z

func moveToRealPosition(boss):
	var pos = Vector3.ZERO;
	pos.x = boss.getRealX(gameX);
	pos.y = boss.getRealY(gameY+groundY)
	pos.z = boss.getRealZ(gameZ);
	set_position(pos)

func groundMotion(boss, delta):
	if needsAdvance:
		shiftGameXZ(1,0)
		deduceGroundY(boss)
		moveToRealPosition(boss)
		needsAdvance = false;

func heldMotion(boss, delta):
	if position.y < -5:
		queue_free()

func fallMotion(boss, delta):
	var velocity = Vector3(0,-1,0)
	position = position + velocity*delta
	if position.y < -5:
		queue_free()

func update(boss, delta):
	motionFuncs[motionState].call(boss, delta)
