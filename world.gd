extends Node3D

@export var ObjectiveBuffer: float = 5.0

enum GameStates {Start, BuildUp1, BuildUp2, Bilp1, BuildUp3, Bilp2}

var State: GameStates = GameStates.Start
var paused: bool = false
var playerCanLock: bool = false
var playerCanTurnOffTV: bool = false
var playerSeenBlip1: bool = false
var voicePlayed: int = 0
@onready var Objective: Label = $ObjectiveContainer/Objective
@onready var PlayerHint: Label = $PlayerHintContainer/PlayerHintLabel
@onready var slightPause: Timer = $Timer
@onready var BlipChar = $BlipChar

@onready var TVStaticVideo: VideoStreamPlayer = $SubViewport/VideoStreamPlayer

#Sounds
@onready var LockDoorSound: AudioStreamPlayer3D = $DoorLockSound 
@onready var TVStaticSound: AudioStreamPlayer3D = $TVStatic
@onready var VoiceSound: AudioStreamPlayer3D = $DisembodiedVoice
@onready var TenseMusic: AudioStreamPlayer = $TenseMusic
@onready var ElectroStatic: AudioStreamPlayer = $ElectroStatic
@onready var BlipIn: AudioStreamPlayer3D = $BlipChar/BlipInSound
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
			LockDoorSound.play()
			
		elif(State == GameStates.Bilp2 and playerCanLock):
			pass
			
		if(State == GameStates.BuildUp1 and playerCanTurnOffTV):
			TVStaticSound.stop()
			TVStaticVideo.stop()
			slightPause.start(1.0)
			State = GameStates.BuildUp2
			Objective.text = "Objective: go to bed"
			


func on_player_canReach_FrontDoor(body):
	if(State == GameStates.Start):
		#continue logic
		if(body is Player):
			playerCanLock = true
			PlayerHint.text = "Press 'E' or LMB to lock door"

	if(State == GameStates.Bilp2):
		if(body is Player):
			playerCanLock = true
			PlayerHint.text = "Press 'E' or LMB to unlock and open door"
	pass # Replace with function body.


func on_player_cantReach_FrontDoor(body):
	if(body is Player):
		playerCanLock = false
		PlayerHint.text = ""
	pass # Replace with function body.


func _on_door_lock_sound_finished():
	State = GameStates.BuildUp1
	slightPause.start(1)
	Objective.text = "Objective: Go to bed"
	
	pass # Replace with function body.

func on_tv_static_finished():
	if(State == GameStates.BuildUp1):
		TVStaticSound.play()


func on_can_reach_TV_entered(body: Node3D)->void:
	if(State == GameStates.BuildUp1):
		if(body is Player):
			playerCanTurnOffTV = true
			PlayerHint.text = "Press 'E' or LMB to turn off TV"
	pass # Replace with function body.

func on_can_reach_tv_exited(body: Node3D)->void:
	if(body is Player):
		playerCanTurnOffTV = false
		PlayerHint.text = ""
	pass

func on_Timer_finished():
	if(State == GameStates.BuildUp1):
		Objective.text = "Objective: turn off that TV!"
		TVStaticSound.play()
		TVStaticVideo.loop = true
		TVStaticVideo.play()
	elif(State == GameStates.BuildUp2 and voicePlayed == 0):
		Objective.text = "Objective: investigate that voice"
		VoiceSound.play()
		voicePlayed = voicePlayed + 1
	elif(State == GameStates.BuildUp2 and voicePlayed > 0):
		rotateVoice(voicePlayed)
		voicePlayed = voicePlayed + 1
		VoiceSound.play()
		slightPause.start(4)
	elif(State == GameStates.Bilp1 and not playerSeenBlip1):
		Objective.text = "Objective: go to bed"
		
	elif(State == GameStates.Bilp1 and playerSeenBlip1):
		BlipChar.global_position = BlipChar.origin
		BlipChar.rotation_degrees = BlipChar.naturalRotation
		BlipIn.stop()
		slightPause.start(5)
		Objective.text = "Objective: ..."
		State = GameStates.BuildUp3
		pass	


func _on_disembodied_voice_finished():
	if(not TenseMusic.playing):
		TenseMusic.play()
	slightPause.stop()
	slightPause.start(5)


func _on_bedroom_entrance_1_body_entered(body):
	if(State == GameStates.Bilp1):
		BlipIn.play()
		BlipChar.rotate_y(deg_to_rad(-90))
		BlipChar.global_position = $BedroomEntrance1/Blip1Spawn1.global_position
		playerSeenBlip1 = true
		slightPause.start(0.5)
	pass # Replace with function body.


func _on_bedroom_entrance_2_body_entered(body):
	if(State == GameStates.Bilp1):
		BlipIn.play()
		BlipChar.rotate_y(deg_to_rad(180))
		BlipChar.global_position = $BedroomEntrance2/Blip1Spawn2.global_position
		playerSeenBlip1 = true
		slightPause.start(0.5)
	pass # Replace with function body.


func _on_mb_entrance_2_body_entered(body):
	mb_entrance_shared_logic()
	pass # Replace with function body.


func _on_mb_entrance_1_body_entered(body):
	mb_entrance_shared_logic()
	pass # Replace with function body.

func mb_entrance_shared_logic():
	#do what both area's need
	if(State == GameStates.BuildUp2):
		TenseMusic.stop()
		slightPause.stop()
		State = GameStates.Bilp1
		slightPause.start(4.0)
		
func rotateVoice(counter: int):
	if(counter % 2 != 0):
		VoiceSound.stream = load("res://Sounds/BlipVA-02.wav")
	else:
		VoiceSound.stream = load("res://Sounds/BlipVA-01.wav")
