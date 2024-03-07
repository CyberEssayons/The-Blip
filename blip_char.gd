extends Node3D

@export var origin: Vector3
@export var naturalRotation: Vector3

signal moveAway()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playAnim():
	$AnimationPlayer.play("reach")


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "reach"):
		emit_signal("moveAway")
	pass # Replace with function body.
