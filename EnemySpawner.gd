extends Node2D


export var enemy_resource : Resource = null
export var target_node : NodePath = ""

onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	if enemy_resource != null:
		timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	var enemy_inst = enemy_resource.instance()
	enemy_inst.target_node = "../{0}".format([target_node])
	add_child(enemy_inst)
