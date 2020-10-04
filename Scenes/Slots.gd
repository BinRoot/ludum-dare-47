extends Node2D

signal slot1_update
signal slot2_update
signal slot3_update

var LEVEL = Globals.LEVEL
var level = LEVEL.level1

onready var slot1_sprite = $Slot1/Sprite2
onready var slot1_box = $Slot1/Sprite
onready var slot1 = $Slot1
onready var slot2_sprite = $Slot2/Sprite2
onready var slot2_box = $Slot2/Sprite
onready var slot2 = $Slot2
onready var slot3_sprite = $Slot3/Sprite2
onready var slot3_box = $Slot3/Sprite
onready var slot3 = $Slot3

onready var slot_states = {
	"slot1": {
		"sprite": slot1_sprite,
		"shape": Globals.SHAPE.point
	},
	"slot2": {
		"sprite": slot2_sprite,
		"shape": Globals.SHAPE.point
	},
	"slot3": {
		"sprite": slot3_sprite,
		"shape": Globals.SHAPE.point
	}
}

var slot_selected = "slot1"

func _ready():
	pass 
	
func _physics_process(delta):
	slot1.show()
	slot2.show()
	slot3.show()
	if level == LEVEL.level1:
		slot2.hide()
		slot3.hide()
	elif level == LEVEL.level2:
		slot3.hide()
	
	var highlight_color = Color.chartreuse
	
	if slot_selected == "slot1":
		slot1_box.modulate = highlight_color
	else:
		slot1_box.modulate = Color.white
		
	if slot_selected == "slot2":
		slot2_box.modulate = highlight_color
	else:
		slot2_box.modulate = Color.white
		
	if slot_selected == "slot3":
		slot3_box.modulate = highlight_color
	else:
		slot3_box.modulate = Color.white
		
	for key in slot_states:
		var shape = slot_states[key]["shape"]
		if shape in Globals.shape_sprites:
			var res = Globals.shape_sprites[shape]
			var sprite : Sprite = slot_states[key]["sprite"]
			sprite.texture = res

func _input(event):
	if event.is_action_pressed("slot1"):
		slot_selected = "slot1"
	if event.is_action_pressed("slot2") and level != LEVEL.level1:
		slot_selected = "slot2"
	if event.is_action_pressed("slot3") and level == LEVEL.level3:
		slot_selected = "slot3"
	
	if event.is_action_pressed("ui_left"):
		var next_shape = Globals.SHAPE.circle_ccw
		emit_signal("{0}_update".format([slot_selected]), next_shape)
		slot_states[slot_selected]["shape"] = next_shape
	if event.is_action_pressed("ui_right"):
		var next_shape = Globals.SHAPE.circle_cw
		emit_signal("{0}_update".format([slot_selected]), next_shape)
		slot_states[slot_selected]["shape"] = next_shape
	if event.is_action_pressed("ui_up"):
		var next_shape = Globals.SHAPE.line
		emit_signal("{0}_update".format([slot_selected]), next_shape)
		slot_states[slot_selected]["shape"] = next_shape
	if event.is_action_pressed("ui_down"):
		var next_shape = Globals.SHAPE.point
		emit_signal("{0}_update".format([slot_selected]), next_shape)
		slot_states[slot_selected]["shape"] = next_shape


func _on_Slot1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		slot_selected = "slot1"


func _on_Slot2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		slot_selected = "slot2"


func _on_Slot3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		slot_selected = "slot3"
