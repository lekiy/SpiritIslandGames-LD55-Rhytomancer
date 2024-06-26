extends AudioStreamPlayer2D

@export var measures := 4
@export var looping := true

var song_position = 0.0
var song_position_in_beats = 1
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

var closest = 0
var time_off_beat = 0.0

signal measure_signal(position)

func _physics_process(_delta):
	if(playing):
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / SignalBus.BEATS_PER_SECOND)) + beats_before_start
		_report_beat()
		
func _report_beat():
	if(last_reported_beat < song_position_in_beats):
		if(measure > measures):
			measure = 1
		SignalBus.beat_signal.emit(song_position_in_beats)
		emit_signal("measure_signal", measure)
		last_reported_beat = song_position_in_beats
		measure+=1

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = SignalBus.BEATS_PER_SECOND
	$StartTimer.start()
	
func play_from_beat(beat, offset):
	play()
	seek(beat * SignalBus.BEATS_PER_SECOND)
	beats_before_start = offset
	measure = beat % 4

	
func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if(song_position_in_beats < beats_before_start - 1):
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix()+AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()


func _on_finished():
	if looping:
		song_position_in_beats = 1
		last_reported_beat = 0
		
		play_with_beat_offset(2)
