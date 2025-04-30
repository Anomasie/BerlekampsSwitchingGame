@tool
extends GridContainer

@export var field_size = Vector2i(10,10)
@export var LampButton : PackedScene

func _ready():
	set_field()

func set_field(new_size=field_size):
	self.columns = new_size.x
	# add or delete children
	var len_children = self.get_child_count()
	var len_expected = new_size.x * new_size.y
	if len_children < len_expected:
		for i in len_expected - len_children:
			self.add_child(LampButton.instantiate())
			self.get_child(-1).set_value(randf() < 0.5)
	elif len_children > len_expected:
		for i in len_children - len_expected:
			self.get_child(-i).queue_free()

func switch_column(i):
	for j in field_size.y:
		self.get_child(i*field_size.x + j).switch_value()

func switch_line(i):
	for j in field_size.x:
		self.get_child(i + field_size.x*j).switch_value()
