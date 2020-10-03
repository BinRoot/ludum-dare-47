extends Node2D

var SHAPE = Globals.SHAPE
export var size1 : int = 100
export var speed1 : int = 1
export var child_path : NodePath = ""
export(Globals.SHAPE) var shape = SHAPE.circle_cw

onready var node = $Node
onready var node_sprite = $Node/Sprite
onready var dropping_timer = $DroppingTimer

var child_path_prefix = "."
var time = 0
var child_inst = null

var dropping_scene = preload("res://Scenes/Dropping.tscn")


func _ready():
	if child_path != "":
		node_sprite.visible = false
		var child_inst_original = get_node("{0}/{1}".format([child_path_prefix, child_path]))
		child_inst = child_inst_original.duplicate()
		child_inst.child_path_prefix = "../../{0}".format([child_path_prefix])
		child_inst_original.queue_free()
		node.monitoring = false
		node.add_child(child_inst)

func attach_child(child):
	node_sprite.visible = false
	child.child_path_prefix = "../../{0}".format([child_path_prefix])
	node.monitoring = false
	node.add_child(child)
	child_inst = child

func _physics_process(delta):
	if child_inst == null:
		if dropping_timer.is_stopped():
			dropping_timer.start()
	else:
		dropping_timer.stop()
	if shape == SHAPE.point:
		node.position.x = size1
	elif shape == SHAPE.circle_cw:
		node.position.x = size1
		rotate(speed1 * delta)
	elif shape == SHAPE.line:
		node.position.x = size1 * sin(time * delta)
	elif shape == SHAPE.circle_ccw:
		node.position.x = size1	
		rotate(-speed1 * delta)
	time = time + 1

func _on_Node_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		var enemy_body : RigidBody2D = area.get_parent()
		if not enemy_body.is_glowing:
			var direction = (area.global_position - global_position).normalized() * 300
			enemy_body.apply_impulse(Vector2.ZERO, direction)
			enemy_body.die()





func _on_DroppingTimer_timeout():
	var dropping_inst = dropping_scene.instance()
	dropping_inst.global_position = node.global_position + Vector2(randi()%10 - 5, randi()%10 - 5)
	get_tree().root.add_child(dropping_inst)
