extends Control

export var text : String = "hello"
onready var label = $CenterContainer/Label
onready var tween = $Tween
var follow = null

func _ready():
	label.text = text
	tween.interpolate_property(label, "margin_top",
		label.margin_top, label.margin_top - 20, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(label, "modulate",
		label.modulate, Color.transparent, 3,
		Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()

func _process(delta):
	if follow != null:
		margin_left = follow.global_position.x
		margin_top = follow.global_position.y


func _on_Timer_timeout():
	queue_free()
