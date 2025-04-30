@tool
extends GridContainer

signal changed

@export var field_size = Vector2i(10,10)
@export var LampButton : PackedScene

func _ready():
	set_field()

func get_score():
	var sum = 0
	for Child in self.get_children():
		sum += int(Child.on)
	return sum

func set_field(new_size=field_size):
	field_size = new_size
	self.columns = new_size.x
	# add or delete children
	var len_children = self.get_child_count()
	var len_expected = new_size.x * new_size.y
	if len_children < len_expected:
		for i in len_expected - len_children:
			self.add_child(LampButton.instantiate())
			self.get_child(-1).pressed.connect(_on_lamp_pressed)
	elif len_children > len_expected:
		for i in len_children - len_expected:
			self.get_child(-i).queue_free()

func empty_field() -> void:
	for Child in self.get_children():
		Child.set_value(false)

func random_field() -> void:
	for Child in self.get_children():
		Child.set_value(randf() < 0.5)

func switch_column(i):
	for j in field_size.y:
		self.get_child(i*field_size.x + j).switch_value()
	changed.emit()

func switch_line(i):
	for j in field_size.x:
		self.get_child(i + field_size.x*j).switch_value()
	changed.emit()

func _on_lamp_pressed():
	changed.emit()
