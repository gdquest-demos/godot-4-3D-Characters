extends Resource

enum MODE {SET, CALL}

@export var list_name : String = ""
@export var mode : MODE
@export var bind_name : String = ""
@export var options_values : PackedStringArray
