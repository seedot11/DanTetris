extends Node2D

@onready var shape := $Shape
var block_size := 32

var shape_mask : Array[Array] = [
	[0, 1, 0],
	[0, 1, 0],
	[1, 1, 0]
]

func _ready() -> void:
	draw_tetronimo()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		rotate_mask()
	if Input.is_action_just_pressed("rotate_anticlockwise"):
		rotate_mask_anticlockwise()
	draw_tetronimo()

func draw_tetronimo() -> void:
	shape.polygon = []
	var width = shape_mask[0].size()
	var length = shape_mask.size()
	
	var starting_x : int = width * (block_size/2) * -1
	var starting_y : int = length * (block_size/2) * -1
	var starting_pos := Vector2(starting_x, starting_y)
	
	var rows : Array[PackedVector2Array] = [] 
	for y in shape_mask.size():
		var row : PackedVector2Array = []
		for x in shape_mask[y].size():
			if shape_mask[y][x] == 0:
				continue
			
			var square : PackedVector2Array = [
				Vector2(starting_x + x * block_size, starting_y + y * block_size),
				Vector2(starting_x + (x + 1) * block_size, starting_y + y * block_size),
				Vector2(starting_x + (x + 1) * block_size, starting_y + (y + 1) * block_size),
				Vector2(starting_x + x * block_size, starting_y + (y + 1) * block_size)
			]
			
			if row.size() == 0:
				row = square
			else:
				row = Geometry2D.merge_polygons(row, square)[0]
		rows.append(row)
	
	for row in rows:
		if shape.polygon.size() == 0:
			shape.polygon = row
		else:
			shape.polygon = Geometry2D.merge_polygons(shape.polygon, row)[0]

func rotate_mask() -> void:
	var size = shape_mask.size()
	var new_shape : Array[Array] = []
	for r in size:
		new_shape.append([])
		for c in size:
			new_shape[r].append(0)
			
	for i in size:
		for j in size:
			new_shape[j][size - i - 1] = shape_mask[i][j]
			
	shape_mask = new_shape
	
func rotate_mask_anticlockwise() -> void:
	var size = shape_mask.size()
	var new_shape : Array[Array] = []
	for r in size:
		new_shape.append([])
		for c in size:
			new_shape[r].append(0)
			
	for i in size:
		for j in size:
			new_shape[size - j - 1][i] = shape_mask[i][j]
			
	shape_mask = new_shape
			
	
	
