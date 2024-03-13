extends Node3D

@onready var Music: AudioStreamPlayer = $AudioStreamPlayer
@onready var TimeBuffer: Timer = $AudioStreamPlayer/Timer
@onready var Anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Anim.play("menu_animation", -1, 0.5)
	Music.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if(not Music.playing):
		Music.play()


func _on_audio_stream_player_finished():
	TimeBuffer.start(3.5)


func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	Anim.play("menu_animation")
