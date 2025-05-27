extends Node3D

@export var dirt_main: PackedScene
@export var dirt_snow: PackedScene
@export var dirt_grass: PackedScene


var equatorLo = 5
var equatorHi = 25

func _ready():
	var xCount=30
	var zCount=30
	for x in range(xCount):
		for z in range(zCount):
			var pos = Vector3(x,-0.5,z)
			var buckets:Array[float] = getBuckets(pos.z)
			var prefab = prefabSelector(buckets);
			var nextfloor = prefab.instantiate()
			pos.x = pos.x - float(xCount)/2.0;
			pos.z = pos.z - float(zCount)/2.0;
			pos.y += floor(3*randf())*0.25
			nextfloor.set_position(pos)
			add_child(nextfloor)

func getBuckets(y:float) -> Array[float]:
	var snow_factor:float = 5
	var grass_factor:float = 3
	var dirt_factor:float = 6
	var padding:float = 5

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

func prefabSelector(buckets:Array[float]):
	var roll = randf()
	if roll < buckets[0]:
		return dirt_snow
	elif roll < buckets[1]:
		return dirt_main
	else:
		return dirt_grass
	
