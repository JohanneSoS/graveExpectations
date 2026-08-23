extends Node2D

@export_category("Music")
@export var full_music : AudioStream
@export var radio_music : AudioStream

@export_category("SFX")
@export var office_ambience : AudioStream
@export var workroom_ambience : AudioStream

@export var bone_crackle : Array[AudioStream]
@export var mouse_click : AudioStream
@export var mouse_hover : AudioStream
@export var drag_bodypart : AudioStream
@export var drop_bodypoart : AudioStream

@onready var radio_music_player: AudioStreamPlayer2D = $radioMusicPlayer
@onready var full_music_player: AudioStreamPlayer2D = $fullMusicPlayer
@onready var work_ambience_player: AudioStreamPlayer2D = $work_ambience
@onready var office_ambience_player: AudioStreamPlayer2D = $office_ambience
@onready var sfx_player: AudioStreamPlayer2D = $sfxPlayer

@onready var activeScreen: GameEnums.ActiveScreens

func _ready():
	initialize_streams()
	on_location_switch(GameEnums.ActiveScreens.Menu)

func initialize_streams():
	radio_music_player.stream = radio_music
	full_music_player.stream = full_music
	radio_music_player.play()
	full_music_player.play()
	work_ambience_player.stream = workroom_ambience
	office_ambience_player.stream = office_ambience
	office_ambience_player.play()
	work_ambience_player.play()

func on_location_switch(screen: GameEnums.ActiveScreens):
	match screen: 
		GameEnums.ActiveScreens.Work:
			work_ambience_player.volume_db = 0.0
			office_ambience_player.volume_db = -80.0
			radio_music_player.volume_db = 0.0
			full_music_player.volume_db = -80.0
		GameEnums.ActiveScreens.Office:
			work_ambience_player.volume_db = -80.0
			office_ambience_player.volume_db = 0.0
			radio_music_player.volume_db = -20
			full_music_player.volume_db = -80.0
		GameEnums.ActiveScreens.Menu:
			work_ambience_player.volume_db = -80.0
			office_ambience_player.volume_db = 0.0
			radio_music_player.volume_db = -80.0
			full_music_player.volume_db = 0.0

func play_pitch_randomized_OneShot(oneshot: AudioStream):
	#randomize()
	sfx_player.pitch_scale = randf_range(0.9,1.1)
	sfx_player.stream = oneshot
	sfx_player.play()
	
func play_randomized_OneShot(oneshot: Array[AudioStream]):
	var random_index = randi_range(0, oneshot.size()-1)
	sfx_player.pitch_scale = randf_range(0.9,1.1)
	sfx_player.stream = oneshot[random_index]
	sfx_player.play()
