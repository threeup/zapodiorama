extends Node3D

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	var target_position = mob_spawn_location.position + Vector3(0,0,-10)
	mob.initialize(mob_spawn_location.position, target_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
