extends Control

@export var BigSwitchScene : PackedScene

@onready var GameField = $Screen/Game/Margin/Grid/GameField
@onready var Lines = $Screen/Game/Margin/Grid/Lines
@onready var Columns = $Screen/Game/Margin/Grid/Columns

@onready var OnLabel = $Screen/CurrentGame/Score/Margin/Grid/LeftLabel
@onready var OffLabel = $Screen/CurrentGame/Score/Margin/Grid/RightLabel

@onready var SizeX = $Screen/NewGame/MainMenu/Margin/Lines/Lines/XEdit
@onready var SizeY = $Screen/NewGame/MainMenu/Margin/Lines/Lines/YEdit
@onready var SubmitButton = $Screen/SubmitButton

enum modi {FIRST_PLAYER, SECOND_PLAYER, MULTIPLAYER, CREATIVE}

var current_modus = 0
var current_stage = 0

func _ready() -> void:
	start_game()

func start_game(modus = current_modus) -> void:
	current_modus = modus
	set_field(Vector2i(SizeX.value, SizeY.value))
	update_score()
	match current_modus:
		modi.FIRST_PLAYER:
			GameField.empty_field()
			set_individual_lamps_disabled(false)
			set_current_stage(0)
			SubmitButton.show()
		modi.SECOND_PLAYER:
			GameField.random_field()
			set_individual_lamps_disabled(true)
			set_current_stage(1)
			SubmitButton.show()
		modi.MULTIPLAYER:
			GameField.empty_field()
			set_individual_lamps_disabled(false)
			set_current_stage(0)
			SubmitButton.show()
		modi.CREATIVE:
			GameField.random_field()
			set_individual_lamps_disabled(false)
			set_current_stage(0)
			SubmitButton.hide()

func set_current_stage(stage = current_stage) -> void:
	match stage:
		0:
			set_individual_lamps_disabled(false)
		1:
			set_individual_lamps_disabled(true)
			if modi.FIRST_PLAYER:
				print("evaluate!")
		_:
			print("evaluate!")

func set_individual_lamps_disabled(value) -> void:
	GameField.set_individual_lamps_disabled(value)

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
	if new_size != GameField.field_size:
		GameField.set_field(new_size)

func update_score(new_score = GameField.get_score()) -> void:
	OnLabel.text = str(new_score)
	OffLabel.text = str(GameField.field_size.x * GameField.field_size.y - new_score)

func _on_columns_child_pressed(i):
	GameField.switch_column(i)

func _on_lines_child_pressed(i):
	GameField.switch_line(i)

func _on_game_field_changed() -> void:
	update_score()

func _on_first_player_pressed() -> void:
	start_game(modi.FIRST_PLAYER)

func _on_second_player_pressed() -> void:
	start_game(modi.SECOND_PLAYER)

func _on_two_player_pressed() -> void:
	start_game(modi.MULTIPLAYER)

func _on_creative_pressed() -> void:
	start_game(modi.CREATIVE)

func _on_submit_button_pressed() -> void:
	set_current_stage(current_stage+1)
