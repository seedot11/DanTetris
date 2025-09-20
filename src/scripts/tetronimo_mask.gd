class_name TetronimoMask

var shape_mask : Array[PackedInt32Array]

func _init(_shape_mask: Array[PackedInt32Array] = []):
	shape_mask = _shape_mask

func get_row(index: int) -> PackedInt32Array:
	return shape_mask[index]
	
func get_cell(row: int, column: int) -> bool:
	return shape_mask[row][column] == 1 

func rotate_mask() -> void:
	var dimensions = get_mask_dimensions()
	shape_mask = pad_mask(shape_mask)
	var size = maxi(dimensions.length, dimensions.width)
	var new_shape : Array[PackedInt32Array] = []
	for r in size:
		new_shape.append(PackedInt32Array())
		for c in size:
			new_shape[r].append(0)
			
	for i in dimensions.length:
		for j in dimensions.width:
			new_shape[j][size - i - 1] = shape_mask[i][j]
			
	shape_mask = trim_trailing_0s(new_shape)
	
func rotate_mask_anticlockwise() -> void:
	var dimensions = get_mask_dimensions()
	shape_mask = pad_mask(shape_mask)
	var size = maxi(dimensions.length, dimensions.width)
	var new_shape : Array[PackedInt32Array] = []
	for r in size:
		new_shape.append(PackedInt32Array())
		for c in size:
			new_shape[r].append(0)
			
	for i in dimensions.length:
		for j in dimensions.width:
			new_shape[size - j - 1][i] = shape_mask[i][j]
			
	shape_mask = trim_trailing_0s(new_shape)
			
func get_mask_dimensions(when_rotated: bool = false) -> TetronimoDimensions:
	var current_width := 0
	var current_height := shape_mask.size()
	
	for r in shape_mask:
		if r.size() > current_width:
			current_width = r.size()
			
	if when_rotated:
		return TetronimoDimensions.new(current_height, current_width)
	else:
		return TetronimoDimensions.new(current_width, current_height)

func pad_mask(mask: Array[PackedInt32Array]) -> Array[PackedInt32Array]:
	if get_mask_dimensions().width > get_mask_dimensions().length:
		for y in get_mask_dimensions().width - get_mask_dimensions().length + 1:
			var new_row := PackedInt32Array()
			for x in get_mask_dimensions().width:
				new_row.append(0)
			mask.append(new_row)
	
	for row in mask:
		if row.size() == get_mask_dimensions().width:
			continue
		for x in range(row.size(), get_mask_dimensions().width):
			row.append(0)
	
	return mask	

## Trims trailing 0s
func trim_trailing_0s(mask: Array[PackedInt32Array]) -> Array[PackedInt32Array]:
	var new_mask : Array[PackedInt32Array] = []
	var pos_of_first_1 = Int.INT_MAX
	
	for r in mask:
		for c in r.size():
			if r[c] == 1:
				if c < pos_of_first_1:
					pos_of_first_1 = c
				continue
	
	for r in mask:
		var pos_of_last_1 = 0
		for c in r.size():
			if r[c] == 1:
				pos_of_last_1 = c + 1
		var new_row = r.slice(maxi(0, pos_of_first_1), maxi(pos_of_first_1, pos_of_last_1))
		if new_row.size() > 0:
			new_mask.append(new_row)
	
	return new_mask
