extends Node2D

var LEVEL = Globals.LEVEL
var level = LEVEL.level1

onready var droppings_area_polygon = $DroppingsArea/CollisionPolygon2D
onready var spinner1 = $Spinner
onready var polygon = $Polygon2D
onready var slots = $Slots
onready var home = $Home
onready var enemy_check_timer = $EnemyCheckTimer
onready var ui = $UI
onready var wahwah_loop = $Wahwah
onready var score_sound = $ScoreSound
onready var health = $Home/Health
onready var game_over_timer = $GameOverTimer
onready var level_up_sound = $LevelUpSound

var spawner_res = preload("res://Scenes/EnemySpawner.tscn")
var spawner_res2 = preload("res://Scenes/SpinningEnemySpawner.tscn")
var spawner_res3 = preload("res://Scenes/DoubleSpinningEnemySpawner.tscn")

var level1_intro = preload("res://Scenes/LevelIntro.tscn")
var is_game_over = false
var enemy_indicator = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	prepare_level1()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if Globals.health <= 0 and not is_game_over:
		you_lose()
	health.value = Globals.health
	health.max_value = Globals.health_max
	var droppings = get_tree().get_nodes_in_group("dropping")
	var dropping_positions = []
	for dropping in droppings:
		dropping_positions.append(dropping.global_position)
	droppings_area_polygon.polygon = dropping_positions
	polygon.polygon = dropping_positions
	ui.margin_right = get_viewport().size.x / 2
	ui.margin_left = get_viewport().size.x / 2
	ui.margin_top = get_viewport().size.y / 2
	ui.margin_bottom = get_viewport().size.y / 2
	slots.position = get_viewport().size / 2
	slots.position.y += min(slots.level, 2) * 50
	slots.position.x *= 0.25
	slots.level = level
	home.position = get_viewport().size / 2
	spinner1.position = get_viewport().size / 2
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	var current_indicator = 0
	for enemy in enemies:
		if not enemy.is_glowing:
			enemy_indicator += 1
			current_indicator += 1
	if current_indicator == 0 and enemy_check_timer.is_stopped():
		enemy_check_timer.start()
		enemy_indicator = 0
	


func _on_DroppingsArea_body_entered(body):
	if body.is_in_group("enemy") and not body.is_glowing:
		body.glow()
		score_sound.play()
#		body.die()


func _on_Slots_slot1_update(value):
	spinner1.shape = value

func _on_Slots_slot2_update(value):
	for spinner in get_tree().get_nodes_in_group("spinner"):
		spinner.is_selected = false
	if spinner1.child_inst == null:
		var child_spinner = preload("res://Scenes/Spinner.tscn").instance()
		child_spinner.shape = value
		child_spinner.size1 = 60
		child_spinner.speed1 = 3
		child_spinner.is_selected = true
		spinner1.attach_child(child_spinner)
	else:
		spinner1.child_inst.is_selected = true
		spinner1.child_inst.shape = value


func _on_Slots_slot3_update(value):
	for spinner in get_tree().get_nodes_in_group("spinner"):
		spinner.is_selected = false
	if spinner1.child_inst != null:
		if spinner1.child_inst.child_inst == null:
			var child_spinner = preload("res://Scenes/Spinner.tscn").instance()
			child_spinner.shape = value
			child_spinner.size1 = 50
			child_spinner.speed1 = 5
			child_spinner.is_selected = true
			spinner1.child_inst.attach_child(child_spinner)
		else:
			spinner1.child_inst.child_inst.shape = value
			spinner1.child_inst.child_inst.is_selected = true
		if value == Globals.SHAPE.circle_cw or value == Globals.SHAPE.circle_ccw:
			if not wahwah_loop.playing:
				wahwah_loop.play()
		else:
			wahwah_loop.stop()


func _on_Level1_button_down():
	prepare_level1()


func _on_Level2_button_down():
	prepare_level2()


func _on_Level3_button_down():
	prepare_level3()

func kill_all_spawners():
	get_tree().call_group("spawner", "queue_free")
#	var spawners = get_tree().get_nodes_in_group("spawner")
#	for spawner in spawners:
#		spawner.queue_free()
		

func show_level_text(text):
	for ui_item in ui.get_children():
		ui_item.queue_free()
	var level1_intro_text = level1_intro.instance()
	level1_intro_text.text = text
	ui.add_child(level1_intro_text)		

func prepare_level1():
	show_level_text("Use the arrow keys")
	level = LEVEL.level1
	kill_all_spawners()
	var spawner = spawner_res.instance()
	spawner.position.x += 400
	spawner.position.y -= 50
	home.add_child(spawner)

func prepare_level2():
	show_level_text("Wrap around your enemies to mind-control them")
	level_up_sound.play()
	level = LEVEL.level2
	kill_all_spawners()
	var spawner = spawner_res2.instance()
	home.add_child(spawner)
	
func prepare_level3():
	show_level_text("getting dizzy?")
	level_up_sound.play()
	kill_all_spawners()
	var spawner = spawner_res3.instance()
	home.add_child(spawner)
	level = LEVEL.level3
	
func prepare_level4():
	show_level_text("finish the fight!")
	level_up_sound.play()
	kill_all_spawners()
	var spawner = spawner_res3.instance()
	var spawner2 = spawner_res3.instance()
	home.add_child(spawner)
	spawner.position.x -= 100
	home.add_child(spawner2)
	spawner2.position.x += 100
	level = LEVEL.level4
	
func you_win():
	show_level_text("You Win!")
	level_up_sound.play()
	kill_all_spawners()
	
	
func you_lose():	
	is_game_over = true
	enemy_check_timer.stop()
	game_over_timer.stop()
	show_level_text("Game over!")
	kill_all_spawners()
	game_over_timer.start()
#	for enemy in get_tree().get_nodes_in_group("enemy"):
#		enemy.queue_free()
#	for dropping in get_tree().get_nodes_in_group("dropping"):
#		dropping.queue_free()
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("dropping", "queue_free")
#	queue_free()
#	get_parent().ui.visible = true
	

func _on_EnemyCheckTimer_timeout():
	if is_game_over:
		return
	if enemy_indicator == 0:
		if level == LEVEL.level1:
			prepare_level2()
		elif level == LEVEL.level2:
			prepare_level3()
		elif level == LEVEL.level3:
			prepare_level4()
		elif level == LEVEL.level4:
			you_win()
		enemy_indicator = 0


func _on_GameOverTimer_timeout():
	print("game over timeout")
	pass
	#get_parent().ui.hide()
	#visible = false
