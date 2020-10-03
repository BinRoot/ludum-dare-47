extends RigidBody2D


export var target_node : NodePath = ""

onready var die_timer = $DieTimer
onready var sprite = $Sprite


var is_glowing = false
var target
var glow_direction : Vector2 = Vector2(0, 0)

func _ready():
	if target_node != "":
		target = get_node(target_node)


func _physics_process(delta):
	if is_glowing:
		glow_direction = (global_position - target.global_position).normalized()
		look_at(global_position + glow_direction)
		if target != null:
			var distance = target.global_position.distance_to(global_position)
			if distance > 50:
				position += (target.global_position - global_position).normalized() * delta * 100
	else:
		if target != null:
			position += (target.global_position - global_position).normalized() * delta * 100
			look_at(target.global_position)
		if target.global_position.distance_to(global_position) < 10:
			queue_free()
	
		
func die():
	die_timer.start()
	
func glow():
	sprite.modulate = Color.blue
	is_glowing = true
	die_timer.stop()
	

func _on_DieTimer_timeout():
	queue_free()
