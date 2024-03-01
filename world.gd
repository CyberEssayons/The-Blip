extends Node3D

enum GameStates {Start, BuildUp1, Buildup2, Bilp1, BuildUp3, Bilp2}

var State: GameStates = GameStates.Start
var paused: bool = false
var playerCanLock: bool = false
@onready var Objective: Label = $ObjectiveContainer/Objective
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if (State == GameStates.Start):
		Objective.text = "Objective: Lock the front door"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#NGL gonna try to avoid using process in the world script
func _process(_delta):
	pass

func _input(event):
	if(event.is_action_pressed("pause")):
		paused = not paused
		if(paused):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if(event.is_action_pressed("interact")):
		if(State == GameStates.Start and playerCanLock):
			#"Lock" the front door
			pass


func on_player_canReach_FrontDoor(body):
	if(State == GameStates.Start):
		#continue logic
		if(body is Player):
			playerCanLock = true
	pass # Replace with function body.


func on_player_cantReach_FrontDoor(body):
	if(body is Player):
		playerCanLock = false
	pass # Replace with function body.


func _on_door_lock_sound_finished():
	State = GameStates.BuildUp1
	#crap now I need to make the TV and start all that stuff
	pass # Replace with function body.
