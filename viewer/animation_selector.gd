extends OptionButton

func setup(values : PackedStringArray):
	clear()
	for value in values:
		add_item(value)
	select(0)
