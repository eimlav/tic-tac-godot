extends Node2D

onready var pieces = $Board/Pieces
onready var start_button = $UI/StartButton
onready var message_box = $UI/MessageBox

var current_player = null
var game_active = false

var state = [
	-1,-1,-1,
	-1,-1,-1,
	-1,-1,-1
]

var win_states = [
	[0,1,2],
	[0,3,6],
	[6,7,8],
	[2,5,8],
	[0,4,8],
	[2,4,6],
	[1,4,7],
	[3,4,5]
]

func _ready():
	for piece in pieces.get_children():
		piece.connect("clicked", self, "on_piece_clicked")
	
	start_button.connect("button_up", self, "on_start_clicked")

func on_start_clicked():
	print("start")
	start()

func start():
	current_player = Common.PlayerType.ONE
	game_active = true

	for piece in pieces.get_children():
		piece.reset()

	start_button.visible = false
	
	state = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
	
	set_message("Player %s's turn" % current_player)


func on_piece_clicked(piece):
	if !game_active:
		return
	
	if !piece.selected:
		var player_piece = get_player_piece(current_player)
		piece.select(player_piece)
		change_player()
		add_player_state(piece.index, current_player)
		check_game_state()

func get_player_piece(current_player):
	if current_player == Common.PlayerType.ONE:
		return Common.PieceType.X
	elif current_player == Common.PlayerType.TWO:
		return Common.PieceType.O

func change_player():
	if current_player == Common.PlayerType.ONE:
		current_player = Common.PlayerType.TWO
	elif current_player == Common.PlayerType.TWO:
		current_player = Common.PlayerType.ONE
	
	set_message("Player %s's turn" % (current_player + 1))

func check_game_state():
	var player_state = get_player_state(current_player)
	
	for win_state in win_states:
		if player_state == win_state:
			set_message("Player %s wins!" % (current_player + 1))
			end_game()

func add_player_state(index : int, player : int):
	state[index] = player

func get_player_state(player : int):
	var positions = []
	
	var counter = 0
	for pos in state:
		if pos == player:
			positions.append(counter)
		counter += 1

	return positions

func set_message(message):
	message_box.text = message

func end_game():
	game_active = false
	start_button.visible = true
