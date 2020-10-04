extends Node2D

var SHAPE = Globals.SHAPE
export var size1 : int = 100
export var speed1 : int = 1
export var child_path : NodePath = ""
export var shape : int = SHAPE.circle_cw
export var is_enemy : bool = false

onready var node = $Node
onready var node_sprite = $Node/AnimatedSprite
onready var dropping_timer = $DroppingTimer
onready var tween = $Tween
onready var cross_sprite = $Cross
onready var hit_sound = $HitSound

var is_selected : bool = false

var child_path_prefix = "."
var time = 0
var child_inst = null

var dropping_scene = preload("res://Scenes/Dropping.tscn")

var prev_dropping_pos : Vector2 = Vector2.ZERO


func _ready():
	if child_path != "":
		node_sprite.visible = false
		var child_inst_original = get_node("{0}/{1}".format([child_path_prefix, child_path]))
		child_inst = child_inst_original.duplicate()
		if child_inst.get("child_path_prefix"):
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
	if is_enemy:
		cross_sprite.visible = false
	if is_selected and not is_enemy:
		cross_sprite.modulate = Color.yellow
	else:
		cross_sprite.modulate = Color.white
	if child_inst == null and not is_enemy:
		if dropping_timer.is_stopped():
			dropping_timer.start()
	else:
		dropping_timer.stop()
		
	if shape == SHAPE.point:
		node_sprite.rotation_degrees = 90
		node_sprite.speed_scale = 0.1
		if not tween.is_active():
			tween.interpolate_property(node, "position",
				node.position, Vector2(0, 0), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			yield(tween, "tween_completed")
	elif shape == SHAPE.line:
		node_sprite.speed_scale = 0.5
		node_sprite.rotation_degrees = 90
		if not tween.is_active():
			var node_target# = Vector2(0, 0)
			var duration = 0.2
			#if node.position.length() < 10:
			node_target = Vector2(size1, 0)
			duration = 0.1
			tween.interpolate_property(node, "position",
			node.position, node_target, duration,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
			yield(tween, "tween_completed")
	elif shape == SHAPE.circle_cw:
		node_sprite.speed_scale = 1
		node_sprite.rotation_degrees = 180
		rotate(speed1 * delta)
		if not tween.is_active():
			tween.interpolate_property(node, "position",
				node.position, Vector2(size1, 0), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			yield(tween, "tween_completed")
	elif shape == SHAPE.circle_ccw:
		node_sprite.speed_scale = 1
		node_sprite.rotation_degrees = 0
		rotate(-speed1 * delta)
		if not tween.is_active():
			tween.interpolate_property(node, "position",
				node.position, Vector2(size1, 0), 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			yield(tween, "tween_completed")
	time = time + 1

func _on_Node_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		var enemy_body : RigidBody2D = area.get_parent()
		if not enemy_body.is_glowing:
			var direction = (
				(area.global_position - global_position).normalized()
			) * 400
			enemy_body.apply_impulse(Vector2.ZERO, direction)
			hit_sound.play()
			enemy_body.die()


func _on_DroppingTimer_timeout():
	if prev_dropping_pos.distance_to(node.global_position) > 1:
		var dropping_inst = dropping_scene.instance()
		dropping_inst.global_position = node.global_position
		get_tree().root.add_child(dropping_inst)
		prev_dropping_pos = dropping_inst.global_position		
