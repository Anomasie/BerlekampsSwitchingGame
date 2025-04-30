extends Control

@export var BigSwitchScene : PackedScene

@onready var GameField = $Screen/Game/Margin/Grid/GameField
@onready var Lines = $Screen/Game/Margin/Grid/Lines
@onready var Columns = $Screen/Game/Margin/Grid/Columns

func _ready() -> void:
	set_field()

func set_children_number(Child, number, function) -> void:
	# add or delete children
	var len_children = Child.get_child_count()
	var len_expected = number
	if len_children < len_expected:
		for i in len_expected - len_children:
			Child.add_child(BigSwitchScene.instantiate())
			Child.get_child(-1).pressed.connect(function.bind(i+len_children))
	elif len_children > len_expected:
		for i in len_children - len_expected:
			Child.get_child(-i).queue_free()

func set_field(new_size=GameField.field_size) -> void:
	set_children_number(Lines, new_size.x, _on_lines_child_pressed)
	set_children_number(Columns, new_size.y, _on_columns_child_pressed)

func _on_columns_child_pressed(i):
	GameField.switch_column(i)

func _on_lines_child_pressed(i):
	GameField.switch_line(i)
