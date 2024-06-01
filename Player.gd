extends Node3D
var a = 2
var b = 3
var label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = $Label
	var resultado = a + b
	label.text = str(resultado)
	print(resultado)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		print("você apertou a barra de espaço")
