extends Node2D


onready var timer = $Timer
onready var tween : Tween = $Tween
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	tween.interpolate_property(sprite, "modulate",
		sprite.modulate, Color.orange, 0.8, 
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	tween.interpolate_property(sprite, "scale",
		sprite.scale * 1, sprite.scale / 3, 2, 
		Tween.TRANS_CUBIC, Tween.EASE_OUT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()
