extends Node3D

@export var mob_scene: PackedScene
var floorMaker = null;
var brickMaker = null;
var flrHeight:PackedInt32Array = []
var flrElement:PackedInt32Array =  []
@export var flrWidth:int = 30
@export var flrLength:int = 26
var halfWidth:float = 0;
var halfLength:float = 0;

func _ready():
	halfWidth = float(flrWidth)/2.0
	halfLength = float(flrLength)/2.0
	$UserInterface/Retry.hide()
	floorMaker = get_node("/root/Main/FloorMaker")
	brickMaker = get_node("/root/Main/BrickMaker")
	for i in range(flrWidth*flrLength):
		flrHeight.append(0)  # Initializing with zeros
		flrElement.append(0)  # Initializing with zeros
	floorMaker.initialize(flrWidth, flrLength)
	brickMaker.initialize(flrWidth, flrLength)

func setHeight(x,z,h:int):
	var idx:int = x*flrWidth+z
	flrHeight.set(idx,h)

func getHeight(x,z)->int:
	var idx:int = x*flrWidth+z
	return flrHeight[idx]

func setElement(x,z,val:int):
	var idx:int = x*flrWidth+z
	flrElement.set(idx,val)

func getElement(x,z)->int:
	var idx:int = x*flrWidth+z
	return flrElement[idx]

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	var target_position = mob_spawn_location.position + Vector3(0,0,-10)
	mob.initialize(mob_spawn_location.position, target_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func getRealX(val)->float:
	return val - halfWidth

func getGameX(val)->float:
	return val + halfWidth

func getRealY(val)->float:
	return val*0.25 + 0.5

func getRealZ(val)->float:
	return val - halfLength

func getGameZ(val)->float:
	return val + halfLength
