extends Control

signal ContinueGame()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if(event.is_action_pressed("pause")):
		EndMenu()
		emit_signal("ContinueGame")

func BeginMenu():
	get_tree().paused = true
	
func EndMenu():
	get_tree().paused = false

func _on_continue_pressed():
	EndMenu()
	emit_signal("ContinueGame")


func _on_quit_pressed():
	get_tree().quit()
