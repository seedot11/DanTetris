class_name TetronimoProperties
extends Resource

@export_multiline var shape_mask : String
@export var color : Color

func get_shape_mask() -> Array[Array]:
	var return_mask : Array[Array] = []
	var rows = shape_mask.split("\n")
	for row in rows:
		var line : Array[int] = []
		return_mask.append(line)
		var values = row.split(",")
		for value in values:
			line.append(int(value.lstrip(" ").rstrip(" ")))
	return return_mask

# Possibly broken
func set_shape_mask(new_mask: Array[Array]) -> void:
	shape_mask = ""
	for row in new_mask:
		shape_mask += (", ".join(row) + "\n")
	if (shape_mask.length() > 0):
		shape_mask = shape_mask.rstrip("\n")
			
