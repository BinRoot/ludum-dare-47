extends Node2D

signal slot1_update
signal slot2_update
signal slot3_update

onready var slot1_sprite = $Slot1/Sprite2
onready var slot2_sprite = $Slot2/Sprite2
onready var slot3_sprite = $Slot3/Sprite2

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

func _ready():
	pass 
	
func _physics_process(delta):
	for key in slot_states:
		var shape = slot_states[key]["shape"]
		if shape in Globals.shape_sprites:
			var res = Globals.shape_sprites[shape]
			var sprite : Sprite = slot_states[key]["sprite"]
			sprite.texture = res

func _input(event):
	if event.is_action_pressed("debug_1"):
		var next_shape = (slot_states["slot1"]["shape"] + 1) % len(Globals.SHAPE.keys())
		emit_signal("slot1_update", next_shape)
		slot_states["slot1"]["shape"] = next_shape
	if event.is_action_pressed("debug_2"):
		var next_shape = (slot_states["slot2"]["shape"] + 1) % len(Globals.SHAPE.keys())
		print("emit {0}".format([next_shape]))
		emit_signal("slot2_update", next_shape)
		slot_states["slot2"]["shape"] = next_shape
	if event.is_action_pressed("debug_3"):
		var next_shape = (slot_states["slot3"]["shape"] + 1) % len(Globals.SHAPE.keys())
		emit_signal("slot3_update", next_shape)
		slot_states["slot3"]["shape"] = next_shape
