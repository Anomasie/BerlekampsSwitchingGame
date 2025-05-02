@tool
extends MarginContainer

signal pressed

@onready var On = $On
@onready var Off = $Off

@export var on = false

@export var tex_on : AtlasTexture
@export var tex_off : AtlasTexture

@export var reverse_textures = true

func _process(_delta):
	if Engine.is_editor_hint() and tex_on and tex_off:
		set_value(bool(on))
		set_textures()

func _ready():
	set_value(bool(on))
	set_textures()
	set_texture_angles()

func set_textures():
	if not reverse_textures:
		On.texture_normal = tex_on.duplicate()
		Off.texture_normal = tex_off.duplicate()
	else:
		On.texture_normal = tex_off.duplicate()
		Off.texture_normal = tex_on.duplicate()

func set_texture_angles():
	var distance = On.texture_normal.region.size
	
	var anchor_on = On.texture_normal.region.position.y
	On.texture_hover = On.texture_normal.duplicate()
	On.texture_pressed = On.texture_normal.duplicate()
	On.texture_disabled = On.texture_normal.duplicate()
	On.texture_normal.region = Rect2(0, anchor_on, distance.x, distance.y)
	On.texture_hover.region = Rect2(1*distance.x, anchor_on, distance.x, distance.y)
	On.texture_pressed.region = Rect2(2*distance.x, anchor_on, distance.x, distance.y)
	On.texture_disabled.region  = Rect2(3*distance.x, anchor_on, distance.x, distance.y)
	
	var anchor_off = Off.texture_normal.region.position.y
	Off.texture_hover = Off.texture_normal.duplicate()
	Off.texture_pressed = Off.texture_normal.duplicate()
	Off.texture_disabled = Off.texture_normal.duplicate()
	Off.texture_normal.region = Rect2(0, anchor_off, distance.x, distance.y)
	Off.texture_hover.region = Rect2(1*distance.x, anchor_off, distance.x, distance.y)
	Off.texture_pressed.region = Rect2(2*distance.x, anchor_off, distance.x, distance.y)
	Off.texture_disabled.region  = Rect2(3*distance.x, anchor_off, distance.x, distance.y)

func set_disabled(value) -> void:
	On.disabled = value
	Off.disabled = value

func switch_value() -> void:
	set_value(not on)

func set_value(val=on) -> void:
	On.visible = not val
	Off.visible = val
	on = val

func set_buttons_disabled(val) -> void:
	On.disabled = val
	Off.disabled = val

func _on_on_pressed() -> void:
	on = true
	pressed.emit()
	set_value()
	On.hide()
	Off.show()

func _on_off_pressed() -> void:
	on = false
	pressed.emit()
	set_value()
	Off.hide()
	On.show()
