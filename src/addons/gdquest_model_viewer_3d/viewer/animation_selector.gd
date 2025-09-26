extends OptionButton

func setup(values: PackedStringArray) -> void:
	clear()
	for value in values:
		add_item(value)
	select(0)
