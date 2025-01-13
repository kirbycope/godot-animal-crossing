extends AudioStreamPlayer
class_name ACVoiceBox

signal characters_sounded(characters)
signal finished_phrase()


const PITCH_MULTIPLIER_RANGE := 0.3
const INFLECTION_SHIFT := 0.4

@export var base_pitch := 3.5 # (float, 2.5, 4.5)

const sounds = {
	"a": preload("res://addons/acvoicebox/Sounds//a.wav"),
	"b": preload("res://addons/acvoicebox/Sounds//b.wav"),
	"c": preload("res://addons/acvoicebox/Sounds//c.wav"),
	"d": preload("res://addons/acvoicebox/Sounds//d.wav"),
	"e": preload("res://addons/acvoicebox/Sounds//e.wav"),
	"f": preload("res://addons/acvoicebox/Sounds//f.wav"),
	"g": preload("res://addons/acvoicebox/Sounds//g.wav"),
	"h": preload("res://addons/acvoicebox/Sounds//h.wav"),
	"i": preload("res://addons/acvoicebox/Sounds//i.wav"),
	"j": preload("res://addons/acvoicebox/Sounds//j.wav"),
	"k": preload("res://addons/acvoicebox/Sounds//k.wav"),
	"l": preload("res://addons/acvoicebox/Sounds//l.wav"),
	"m": preload("res://addons/acvoicebox/Sounds//m.wav"),
	"n": preload("res://addons/acvoicebox/Sounds//n.wav"),
	"o": preload("res://addons/acvoicebox/Sounds//o.wav"),
	"p": preload("res://addons/acvoicebox/Sounds//p.wav"),
	"q": preload("res://addons/acvoicebox/Sounds//q.wav"),
	"r": preload("res://addons/acvoicebox/Sounds//r.wav"),
	"s": preload("res://addons/acvoicebox/Sounds//s.wav"),
	"t": preload("res://addons/acvoicebox/Sounds//t.wav"),
	"u": preload("res://addons/acvoicebox/Sounds//u.wav"),
	"v": preload("res://addons/acvoicebox/Sounds//v.wav"),
	"w": preload("res://addons/acvoicebox/Sounds//w.wav"),
	"x": preload("res://addons/acvoicebox/Sounds//x.wav"),
	"y": preload("res://addons/acvoicebox/Sounds//y.wav"),
	"z": preload("res://addons/acvoicebox/Sounds//z.wav"),
	"th": preload("res://addons/acvoicebox/Sounds//th.wav"),
	"sh": preload("res://addons/acvoicebox/Sounds//sh.wav"),
	" ": preload("res://addons/acvoicebox/Sounds//blank.wav"),
	".": preload("res://addons/acvoicebox/Sounds//longblank.wav")
}


var remaining_sounds := []


func _ready():
	connect("finished", play_next_sound)


func play_string(in_string: String):
	parse_input_string(in_string)
	play_next_sound()


func play_next_sound():
	if len(remaining_sounds) == 0:
		emit_signal("finished_phrase")
		return
	var next_symbol = remaining_sounds.pop_front()
	emit_signal("characters_sounded", next_symbol.characters)
	# Skip to next sound if no sound exists for text
	if next_symbol.sound == "":
		play_next_sound()
		return
	var sound: AudioStreamWAV = sounds[next_symbol.sound]
	# Add some randomness to pitch plus optional inflection for end word in questions
	pitch_scale = base_pitch + (PITCH_MULTIPLIER_RANGE * randf()) + (INFLECTION_SHIFT if next_symbol.inflective else 0.0)
	stream = sound
	play()


func parse_input_string(in_string: String):
	for word in in_string.split(" "):
		parse_word(word)
		add_symbol(" ", " ", false)
  

func parse_word(word: String):
	var skip_char := false
	var is_inflective := word[-1] == "?"
	for i in range(len(word)):
		if skip_char:
			skip_char = false
			continue
		# If not the last letter, check if next letter makes a two letter substring, e.g. "th"
		if i < len(word) - 1:
			var two_character_substring = word.substr(i, i+2)
			if two_character_substring.to_lower() in sounds.keys():
				add_symbol(two_character_substring.to_lower(), two_character_substring, is_inflective)
				skip_char = true
				continue
		# Otherwise check if single character has matching sound, otherwise add a blank character
		if word[i].to_lower() in sounds.keys():
			add_symbol(word[i].to_lower(), word[i], is_inflective)
		else:
			add_symbol("", word[i], false)


func add_symbol(sound: String, characters: String, inflective: bool):
	remaining_sounds.append({
		"sound": sound,
		"characters": characters,
		"inflective": inflective
	})
