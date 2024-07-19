extends Sprite2D

signal grabbed

@export var type: String




func _on_area_2d_body_entered(body):
	print("entered")
	grabbed.emit(type)
	queue_free()
