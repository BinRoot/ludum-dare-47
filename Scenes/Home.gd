extends Node2D

onready var hurt_audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("enemy") and not area.get_parent().is_glowing:
		Globals.health -= 1
		hurt_audio.play()
