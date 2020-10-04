extends RigidBody2D


onready var die_timer = $DieTimer
onready var sprite = $AnimatedSprite

onready var chat_bubble = preload("res://Scenes/ChatBubble.tscn")

var is_glowing = false
var target
var glow_direction : Vector2 = Vector2(0, 0)

var prev_chat_inst = null

func chat(text):
	if prev_chat_inst != null and is_instance_valid(prev_chat_inst):
		return
	prev_chat_inst = chat_bubble.instance()
	prev_chat_inst.text = text
	prev_chat_inst.follow = self
	get_tree().get_root().add_child(prev_chat_inst)

func _ready():
	if randi() % 4 == 0:
		chat(nlg_enemy_spawn[randi() % len(nlg_enemy_spawn)])


func _physics_process(delta):
	if is_glowing:
		sprite.speed_scale = 0.2
		glow_direction = (global_position - target.global_position).normalized()
		look_at(global_position + glow_direction)
		if target != null:
			var distance = target.global_position.distance_to(global_position)
			if distance > 50:
				position += (target.global_position - global_position).normalized() * delta * 100
	else:
		if target != null:
			var travel_speed = 100
			if target.global_position.distance_to(global_position) > 300:
				apply_impulse(Vector2.ZERO, (target.global_position - global_position).normalized() * delta * 50)
			position += (target.global_position - global_position).normalized() * delta * travel_speed
			look_at(target.global_position)
		if target.global_position.distance_to(global_position) < 10:
			queue_free()
	

func die():
	die_timer.start()
	if randi() % 3 == 0:
		chat(nlg_enemy_dies[randi() % len(nlg_enemy_dies)])
	
func glow():
	sprite.modulate = Color.blue
	is_glowing = true
	die_timer.stop()

func _on_DieTimer_timeout():
	queue_free()
	
const nlg_enemy_spawn = [
	"Snake!",
	"Die serpent!",
	"Give up!",
	"Fight me...",
	"Charge!"
]

const nlg_enemy_dies = [
	"Awkk!",
	"Ooogh!",
	"Ahh!"
]
