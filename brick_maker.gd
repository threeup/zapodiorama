extends Node3D

@export var brick_red: PackedScene
@export var brick_blue: PackedScene
@export var brick_green: PackedScene
@export var brick_yellow: PackedScene
var boss = null


var boardWidth = 0
var boardLength = 0 # elements per column

var activeBricks:Array=[]

func _ready():
	boss = get_node("/root/Main")

func initialize(w,l):
	boardWidth = w
	boardLength = l
	makeColumn(0, 3)
	makeColumn(1, 2)
	makeColumn(2, 2)
	makeColumn(3, 1)

func makeColumn(x, depth):
	for z in range(boardLength):
		for y in range(depth):
			
			var buckets:Array[float] = getBuckets()
			var prefab = prefabSelector(buckets);
			var brick = prefab.instantiate()
			brick.setGameXZ(x,z)
			brick.setGameY(y*4)
			brick.deduceGroundY(boss)
			brick.moveToRealPosition(boss)
			add_child(brick)
			activeBricks.append(brick)

func getBuckets() -> Array[float]:
	return [0.3,0.6,0.9,1.0]

func prefabSelector(buckets:Array[float]):
	var roll = randf()
	if roll < buckets[0]:
		return brick_red
	elif roll < buckets[1]:
		return brick_blue
	elif roll < buckets[2]:
		return brick_green
	else:
		return brick_yellow
	
func shiftAll():
	var finalEdge = float(boardWidth)/2.0 - 2;
	for i in range(activeBricks.size() - 1, -1, -1):
		var brick = activeBricks[i]
		brick.shiftGameXZ(1,0)
		brick.deduceGroundY(boss)
		brick.moveToRealPosition(boss)

		if brick.position.x > finalEdge:
			activeBricks.remove_at(i) 
			brick.queue_free()  

func _on_mob_timer_timeout():
	shiftAll();
	var roll = randf()
	if roll > 0.8:
		makeColumn(0,3)
	elif roll > 0.4:
		makeColumn(0,2)
	else:
		makeColumn(0,1)
