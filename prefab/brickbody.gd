extends StaticBody3D

var gameX:int = 0
var gameY:int = 0
var groundY:int = 0
var gameZ:int = 0

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
