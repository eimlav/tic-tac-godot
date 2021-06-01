extends Node2D

signal clicked

const OTexture = preload("res://assets/o.png")
const XTexture = preload("res://assets/x.png")

export(Common.PieceType) var type = Common.PieceType.X setget set_type, get_type
export(int) var index = 0

onready var sprite = $Sprite

var enabled = false
var selected = false

func _ready():
	self.set_type(type)
	
	reset()
	enabled = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.is_action_released("click"):
		emit_signal("clicked", self)

func set_type(type : int):
	if type == Common.PieceType.X:
		sprite.texture = XTexture
	elif type == Common.PieceType.O:
		sprite.texture = OTexture
		
func get_type():
	return type

func select(type : int):
	if enabled:
		self.type = type
		selected = true
		enabled = false
		sprite.visible = true

func reset():
	enabled = true
	selected = false
	sprite.visible = false
