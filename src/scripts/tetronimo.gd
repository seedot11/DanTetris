extends Node2D

@onready var shape := $Shape
var shape_mask : TetronimoMask
@export var properties : TetronimoProperties

func _ready() -> void:
	shape.color = properties.color
	shape_mask = properties.get_shape_mask()
	draw_tetronimo()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		shape_mask.rotate_mask()
	if Input.is_action_just_pressed("rotate_anticlockwise"):
		shape_mask.rotate_mask_anticlockwise()
	draw_tetronimo()

func draw_tetronimo() -> void:
	shape.polygon = []
	var dimensions = shape_mask.get_mask_dimensions()
	
	var starting_x : int = dimensions.width * Sizes.BLOCK_SIZE/2.0 * -1
	var starting_y : int = dimensions.length * Sizes.BLOCK_SIZE/2.0 * -1
	
	var rows : Array[PackedVector2Array] = [] 
	for y in dimensions.length:
		var row : PackedVector2Array = []
		for x in shape_mask.get_row(y).size():
			if !shape_mask.get_cell(y, x):
				continue
			
			var square : PackedVector2Array = [
				Vector2(starting_x + x * Sizes.BLOCK_SIZE, starting_y + y * Sizes.BLOCK_SIZE),
				Vector2(starting_x + (x + 1) * Sizes.BLOCK_SIZE, starting_y + y * Sizes.BLOCK_SIZE),
				Vector2(starting_x + (x + 1) * Sizes.BLOCK_SIZE, starting_y + (y + 1) * Sizes.BLOCK_SIZE),
				Vector2(starting_x + x * Sizes.BLOCK_SIZE, starting_y + (y + 1) * Sizes.BLOCK_SIZE)
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
	
	
