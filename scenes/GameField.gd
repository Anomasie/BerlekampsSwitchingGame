@tool
extends GridContainer

signal changed

@export var field_size = Vector2i(10,10)
@export var LampButton : PackedScene

func _ready() -> void:
	set_field()

func get_score() -> int:
	var sum = 0
	for Child in self.get_children():
		sum += int(Child.on)
	return sum

func get_winner() -> int:
	var score = get_score()
	return int(score >= field_size.x * field_size.y / 2)

func set_individual_lamps_disabled(value) -> void:
	for Child in self.get_children():
		Child.set_buttons_disabled(value)

func set_field(new_size=field_size) -> void:
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

func switch_all() -> void:
	for i in field_size.x:
		switch_column(i)
	changed.emit()

func switch_column(i) -> void:
	for j in field_size.y:
		self.get_child(j*field_size.x + i).switch_value()
	changed.emit()

func switch_line(i) -> void:
	for j in field_size.x:
		self.get_child(i*field_size.x + j).switch_value()
	changed.emit()

func switch_columns_random() -> void:
	for i in field_size.x:
		if randf() < 0.5:
			switch_column(i)

func switch_lines_random() -> void:
	for j in field_size.y:
		if randf() < 0.5:
			switch_line(j)

func random_player_two() -> void:
	switch_columns_random()
	switch_lines_random()
	if get_score() < 0.5 * field_size.x * field_size.y:
		switch_all()

# signals

func _on_lamp_pressed() -> void:
	changed.emit()
