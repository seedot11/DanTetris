class_name TetronimoProperties
extends Resource

@export_multiline var shape_mask : String
@export var color : Color

func get_shape_mask() -> TetronimoMask:
	var return_mask : Array[PackedInt32Array] = []
	var rows = shape_mask.split("\n")
	for row in rows:
		var line : PackedInt32Array = []
		return_mask.append(line)
		var values = row.split(",")
		for value in values:
			line.append(int(value.lstrip(" ").rstrip(" ")))
	return TetronimoMask.new(return_mask)
			
