extends AudioStreamPlayer2D

@export var bpm := 60
@export var measures := 4

var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

var closest = 0
var time_off_beat = 0.0

signal beat_signal(position)
signal measure_signal(position)

func _physics_process(_delta):
	if(playing):
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()
		
func _report_beat():
	if(last_reported_beat < song_position_in_beats):
		if(measure > measures):
			measure = 1
		emit_signal("beat_signal", song_position_in_beats)
		emit_signal("measure_signal", measure)
		last_reported_beat = song_position_in_beats
		measure+=1

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()
	
func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % 4

	
func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if(song_position_in_beats < beats_before_start - 1):
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait - (AudioServer.get_time_to_next_mix()+AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()