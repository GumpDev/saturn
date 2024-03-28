extends Node

@onready var saturn_player: SaturnStatePlayer = $SaturnStatePlayer
var state: TestDataAdapter.State

func _ready():
	saturn_player.state_changed.connect(func ():
		print(saturn_player.get_state())
		state = saturn_player.get_state()
	)

func _physics_process(_delta):
	saturn_player.set_argument("space", Input.is_action_pressed("space"))
	if Input.is_action_pressed("ctrl"):
		saturn_player.lock_state("2", 2)
