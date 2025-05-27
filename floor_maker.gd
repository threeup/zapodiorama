extends Node3D

@export var dirt_main: PackedScene
@export var dirt_snow: PackedScene
@export var dirt_grass: PackedScene
var boss = null

var boardWidth = 0
var boardLength = 0
var equatorLo = 0
var equatorHi = 0

func _ready():
	boss = get_node("/root/Main")
	

func initialize(w, l):
	boardWidth = w
	boardLength = l
	equatorLo = 4
	equatorHi = boardLength-4
	var y = -4
	for x in range(boardWidth):
		for z in range(boardLength):
			var buckets:Array[float] = getBuckets(z)
			var element = bucketSelector(buckets);
			boss.setElement(x,z, element)
			var nextfloor = prefabSelector(element).instantiate()

			var nextHeight=floor(3*randf())
			boss.setHeight(x,z, nextHeight)
			
			var pos = Vector3.ZERO
			pos.x = boss.getRealX(x);
			pos.y = boss.getRealY(y+nextHeight)
			pos.z = boss.getRealZ(z);
			nextfloor.set_position(pos)
			add_child(nextfloor)

func getBuckets(y:float) -> Array[float]:
	var snow_factor:float = 5
	var grass_factor:float = 3
	var dirt_factor:float = 6
	var padding:float = 0.2*boardLength

	var weight_snow:float = snow_factor * (max(0,equatorLo-y) + max(0,y-equatorHi))
	var weight_dirt:float = dirt_factor;
	var loPadding:float = equatorLo+padding;
	var hiPadding:float = equatorHi-padding;
	var weight_grass:float = grass_factor * (clamp(hiPadding-y,-5,0) + max(0,y-equatorLo) + min(0,loPadding-y))
	var tot_weight:float = weight_snow+weight_dirt+weight_grass
	var bucketSnow:float = weight_snow/tot_weight
	var bucketDirt:float = (weight_snow+weight_dirt)/tot_weight
	var bucketGrass:float = 1.0
	return [bucketSnow,bucketDirt, bucketGrass]

func bucketSelector(buckets:Array[float]):
	var roll = randf()
	for i in range(buckets.size()):
		if roll < buckets[i]:
			return i
	return buckets.size()-1
	
func prefabSelector(idx:int):
	match idx:
		0: return dirt_snow;
		1: return dirt_main;
		2: return dirt_grass;
		_: return dirt_main;
