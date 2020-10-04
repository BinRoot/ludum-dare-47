extends Node2D


export var max_spawns : int = 100
export var spawn_delay : float = 0.5

func _ready():
	$EnemySpawner.max_spawns = max_spawns
	$EnemySpawner.spawn_delay = spawn_delay


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
