extends Control

onready var ui = $Control
onready var snake_sprite = $Control/CrazySnake
onready var eggs_sprite = $Control/Eggs

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	snake_sprite.position = get_viewport().size / 2
	eggs_sprite.position = get_viewport().size / 2
	eggs_sprite.position.y *= 1.75


func _on_Button_pressed():
	ui.hide()
	var main = preload("res://Scenes/Main.tscn").instance()
	add_child(main)
