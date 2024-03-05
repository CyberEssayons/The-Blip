class_name Door
extends Node3D

@export var DoorName: StringName = ""
var toggle = false
var canInteract = false
var playerInArea = false

signal playerInInteractRange(door_name: StringName)
signal playerLeftInteractRange(door_name: StringName)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func openDoorIn(door_name: StringName):
	if(door_name == DoorName and canInteract):
		canInteract = false
		$AnimationPlayer.play("Open_in")
		
func openDoorOut(door_name: StringName):
	if(door_name == DoorName and canInteract):
		canInteract = false
		$AnimationPlayer.play("Open_out")
		
func closeDoorIn(door_name: StringName):
	if(door_name == DoorName and canInteract):
		canInteract = false
		$AnimationPlayer.play("Close_in")
		
func closeDoorOut(door_name: StringName):
	if(door_name == DoorName and canInteract):
		canInteract = false
		$AnimationPlayer.play("Close_out")


func _on_can_open_body_entered(body):
	if(body is Player):
		canInteract = true
		playerInArea = true
		emit_signal("playerInInteractRange", DoorName)
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	if(playerInArea):
		canInteract = true
	pass # Replace with function body.


func _on_can_open_body_exited(body):
	if(body is Player):
		canInteract = false
		playerInArea = false
		emit_signal("playerLeftInteractRange", DoorName)
	pass # Replace with function body.