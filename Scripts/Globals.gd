extends Node

enum LEVEL { level1, level2, level3, level4 }

enum SHAPE { point, circle_cw, line, circle_ccw }

var health = 50
var health_max = 50

var shape_sprites = {
	SHAPE.circle_cw: preload("res://Assets/circle_cw.png"),
	SHAPE.line: preload("res://Assets/line.png"),
	SHAPE.circle_ccw: preload("res://Assets/circle_ccw.png"),
	SHAPE.point: preload("res://Assets/dot.png")
}
