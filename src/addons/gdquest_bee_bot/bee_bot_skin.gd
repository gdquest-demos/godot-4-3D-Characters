extends Node3D

@onready var _animation_tree : AnimationTree = $AnimationTree
@onready var _main_state_machine : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _secondary_action_timer : Timer = $SecondaryActionTimer


func _on_secondary_action_timer_timeout():
	if _main_state_machine.get_current_node() != "Idle": return
	_main_state_machine.travel("HeadMovement")
	_secondary_action_timer.start(randf_range(3.0, 8.0))
	
## Sets the model to a neutral, action-free state.
func idle():
	_main_state_machine.travel("Idle")
	_secondary_action_timer.start()

## Plays a one-shot attack animation.
## This animation does not play in parallel with other states.
func attack():
	_main_state_machine.travel("Attack")

## Plays a one-shot power-off animation.
## This animation does not play in parallel with other states.
func power_off():
	_main_state_machine.travel("PowerOff")
	_secondary_action_timer.stop()
	
