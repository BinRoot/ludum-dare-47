extends Node2D


var enemy_resource = preload("res://Scenes/Enemy1.tscn")
#export var target_node : NodePath = ""
export var max_spawns : int = 10
export var spawn_delay : float = 1

onready var timer = $Timer
onready var home = get_tree().get_nodes_in_group("home")[0]

var num_spawns = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = spawn_delay
	if enemy_resource != null:
		timer.wait_time = timer.wait_time + randf()
		timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	if num_spawns < max_spawns:
		var enemy_inst = enemy_resource.instance()
		enemy_inst.target = home
		enemy_inst.global_position = global_position
		enemy_inst.global_position += Vector2(randi() % 10 - 5, randi() % 10 - 5)
		get_tree().get_root().add_child(enemy_inst)
		num_spawns += 1
