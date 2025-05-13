extends Control

@export var BigSwitchScene : PackedScene

@onready var GameField = $Screen/Center/Game/Margin/Grid/GameField
@onready var Lines = $Screen/Center/Game/Margin/Grid/Lines
@onready var Columns = $Screen/Center/Game/Margin/Grid/Columns

@onready var RandomButton = $Screen/Center/Tools/Margin/Lines/Random

@onready var OnLabel = $Screen/CurrentGame/Score/Margin/Grid/LeftLabel
@onready var OffLabel = $Screen/CurrentGame/Score/Margin/Grid/RightLabel

@onready var SizeX = $Screen/NewGame/MainMenu/Margin/Lines/Lines/XEdit
@onready var SizeY = $Screen/NewGame/MainMenu/Margin/Lines/Lines/YEdit
@onready var CurrentModeLabel = $Screen/NewGame/PlayerMenu/Margin/Lines/CurrentMode
@onready var CurrentPlayerLabel = $Screen/NewGame/PlayerMenu/Margin/Lines/CurrentPlayer
@onready var SubmitButton = $Screen/NewGame/PlayerMenu/Margin/Lines/SubmitButton

enum modi {FIRST_PLAYER, SECOND_PLAYER, MULTIPLAYER, CREATIVE}

var current_modus = 0
var current_stage = 0

func _ready() -> void:
	start_game()

func start_game(modus = current_modus) -> void:
	current_modus = modus
	set_field(Vector2i(SizeX.value, SizeY.value))
	update_score()
	CurrentModeLabel.text = "Mode: "
	match current_modus:
		modi.FIRST_PLAYER:
			GameField.empty_field()
			set_individual_lamps_disabled(false)
			set_current_stage(0)
			SubmitButton.show()
			CurrentModeLabel.text += "1st Player"
		modi.SECOND_PLAYER:
			GameField.random_field()
			set_individual_lamps_disabled(true)
			set_current_stage(1)
			SubmitButton.show()
			CurrentModeLabel.text += "2nd Player"
		modi.MULTIPLAYER:
			GameField.empty_field()
			set_individual_lamps_disabled(false)
			set_current_stage(0)
			SubmitButton.show()
			CurrentModeLabel.text += "Local Multi"
		modi.CREATIVE:
			GameField.random_field()
			set_individual_lamps_disabled(false)
			set_current_stage(0)
			CurrentModeLabel.text += "Creative"

func set_current_stage(stage = current_stage) -> void:
	current_stage = stage
	match stage:
		0:
			SubmitButton.text = "Ready"
			if current_modus == modi.CREATIVE:
				CurrentPlayerLabel.text = "Creative mode"
			else:
				CurrentPlayerLabel.text = "Current Player: 1"
			set_individual_lamps_disabled(false)
		1:
			SubmitButton.text = "Ready"
			if current_modus == modi.FIRST_PLAYER:
				GameField.random_player_two()
				evaluate()
			elif current_modus == modi.CREATIVE:
				current_stage = 0
				evaluate()
			else:
				CurrentPlayerLabel.text = "Current Player: 2"
				set_individual_lamps_disabled(true)
		_:
			evaluate()

func set_individual_lamps_disabled(value) -> void:
	GameField.set_individual_lamps_disabled(value)
	RandomButton.disabled = value

func set_children_number(Child, number, function) -> void:
	# delete all
	# add or delete children
	var len_children = Child.get_child_count()
	var len_expected = number
	if len_children < len_expected:
		for i in len_expected - len_children:
			Child.add_child(BigSwitchScene.instantiate())
			Child.get_child(-1).pressed.connect(function.bind(i+len_children))
	elif len_children > len_expected:
		for i in len_children - len_expected:
			Child.get_child(-i-1).queue_free()

func set_field(new_size=GameField.field_size) -> void:
	set_children_number(Columns, new_size.x, _on_columns_child_pressed)
	set_children_number(Lines, new_size.y, _on_lines_child_pressed)
	if new_size != GameField.field_size:
		GameField.set_field(new_size)

func update_score(new_score = GameField.get_score()) -> void:
	OnLabel.text = str(new_score)
	OffLabel.text = str(GameField.field_size.x * GameField.field_size.y - new_score)

func evaluate():
	if GameField.get_winner() == 0:
		CurrentPlayerLabel.text = "Player 1 wins"
	else:
		CurrentPlayerLabel.text = "Player 2 wins"
	SubmitButton.text = "Evaluate again"

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

func _on_big_switch_pressed() -> void:
	GameField.switch_all()

## tools

func _on_random_pressed() -> void:
	GameField.random_field()

func _on_random_col_pressed() -> void:
	GameField.switch_columns_random()

func _on_random_line_pressed() -> void:
	GameField.switch_lines_random()
