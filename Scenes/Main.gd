extends Node2D


onready var droppings_area_polygon = $DroppingsArea/CollisionPolygon2D
onready var spinner1 = $Spinner
onready var spinner2 = $Spinner2
onready var spinner3 = $Spinner3
onready var polygon = $Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var droppings = get_tree().get_nodes_in_group("dropping")
	var dropping_positions = []
	for dropping in droppings:
		dropping_positions.append(dropping.global_position)
	droppings_area_polygon.polygon = dropping_positions
	polygon.polygon = dropping_positions


func _on_DroppingsArea_body_entered(body):
	if body.is_in_group("enemy"):
		body.glow()
#		body.die()


func _on_Slots_slot1_update(value):
	spinner1.shape = value


func _on_Slots_slot2_update(value):
	if spinner1.child_inst == null:
		var child_spinner = preload("res://Scenes/Spinner.tscn").instance()
		child_spinner.shape = value
		child_spinner.size1 = 50
		child_spinner.speed1 = 4
		spinner1.attach_child(child_spinner)
	else:
		spinner1.child_inst.shape = value


func _on_Slots_slot3_update(value):
	if spinner1.child_inst != null:
		if spinner1.child_inst.child_inst == null:
			var child_spinner = preload("res://Scenes/Spinner.tscn").instance()
			child_spinner.shape = value
			spinner1.child_inst.attach_child(child_spinner)
		else:
			spinner1.child_inst.child_inst.shape = value
