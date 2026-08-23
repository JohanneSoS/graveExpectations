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

@onready var radio_music_player = $radioMusicPlayer
@onready var full_music_player = $fullMusicPlayer
@onready var work_ambience_player = $work_ambience
@onready var office_ambience_player = $office_ambience
@onready var sfx_player = $sfxPlayer

@onready var workRoomActive : bool

func _ready():
	initialize_streams()
	workRoomActive = false

func initialize_streams():
	radio_music_player.stream = radio_music
	full_music_player.stream = full_music
	radio_music_player.play
	full_music_player.play
	work_ambience_player.stream = workroom_ambience
	office_ambience_player.stream = office_ambience
	office_ambience_player.play
	work_ambience_player.play

func on_location_switch():
	if workRoomActive:
		workroom_ambience.volume = 1
		office_ambience.volume = 0
		radio_music_player.volume = 1
		full_music_player.volume = 0
		workRoomActive = true
	else:
		workroom_ambience.volume = 0
		office_ambience.volume = 1
		radio_music_player.volume = 0.3
		full_music_player.volume = 0
		workRoomActive = false
