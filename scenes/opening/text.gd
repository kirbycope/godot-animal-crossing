extends RichTextLabel

# Speed at which new characters appear (in seconds)
@export var character_delay: float = 0.05
@export var punctuation_delay: float = 0.2

# List of punctuation marks that should pause for longer
var punctuation_marks = ['.', '!', '?', ',']

var _current_text: String = ""
var _displayed_text: String = ""
var _char_index: int = 0
var _is_typing: bool = false
var _timer: Timer


func _ready():
	# Create and configure the timer
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.timeout.connect(_on_timer_timeout)

	# Initialize with empty text
	text = ""


func start_typing(new_text: String):
	# Reset variables
	_current_text = new_text
	_displayed_text = ""
	_char_index = 0
	_is_typing = true

	# Start the typing effect
	_type_next_character()


func _type_next_character():
	if _char_index < _current_text.length():
		# Add the next character
		_displayed_text += _current_text[_char_index]
		text = _displayed_text

		# Determine delay for next character
		var delay = character_delay
		if _char_index < _current_text.length() - 1:
			var current_char = _current_text[_char_index]
			if current_char in punctuation_marks:
				delay = punctuation_delay

		# Start timer for next character
		_timer.start(delay)
		_char_index += 1
	else:
		_is_typing = false
		typing_finished.emit()


func _on_timer_timeout():
	if _is_typing:
		_type_next_character()


# Signal emitted when typing is complete
signal typing_finished


# Skip the typing animation
func skip_typing():
	_timer.stop()
	_displayed_text = _current_text
	text = _displayed_text
	_is_typing = false
	typing_finished.emit()


# Check if currently typing
func is_typing() -> bool:
	return _is_typing
