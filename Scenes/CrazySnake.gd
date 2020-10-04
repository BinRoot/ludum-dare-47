extends Control

onready var ui = $Control
onready var snake_sprite = $Control/CrazySnake
onready var eggs_sprite = $Control/Eggs
onready var play_button = $Control/Button
onready var background = $Background
onready var full_screen_button = $FullScreenButton
onready var begin_sound = $BeginSound

var main_res = preload("res://Scenes/Main.tscn")
var main = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	snake_sprite.position = get_viewport().size / 2
	eggs_sprite.position = get_viewport().size / 2
	play_button.margin_left = get_viewport().size.x / 2 - play_button.rect_size.x / 2
	play_button.margin_top = get_viewport().size.y / 2 - play_button.rect_size.y / 2
	eggs_sprite.position.y *= 1.75
	background.rect_scale.x = get_viewport().size.x / 1024
	background.rect_scale.y = get_viewport().size.y / 600
	full_screen_button.margin_left = get_viewport().size.x - full_screen_button.rect_size.x
	full_screen_button.margin_top = get_viewport().size.y - full_screen_button.rect_size.y

func _on_Button_pressed():
	#ui.hide()
	ui.visible = false
	
	if main != null and is_instance_valid(main):
		main.queue_free()
		main.visible = false
	begin_sound.play()
	main = main_res.instance()
	add_child(main)
	print(main)


func _on_FullScreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
