extends Control

export var text : String = "Level 1"

onready var tween : Tween = $Tween
onready var label : Label = $CenterContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = text
	tween.interpolate_property(label, "rect_scale", 
		label.rect_scale, label.rect_scale * 1.1, 0.5, 
		Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(label, "modulate", 
		label.modulate, Color.transparent, 5, 
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(label, "margin_top", 
		label.margin_top, label.margin_top - 200, 3, 
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
