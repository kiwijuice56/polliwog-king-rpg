class_name Action
extends Node

export var display_name: String
export var priority: int

var turn_cycle: Node # Cyclic reference with TurnCycle
var action_owner: Fighter

signal action_completed

static func _compare(a: ActionCall, b: ActionCall) -> bool:
	return a.action.priority < b.action.priority

func _on_event_triggered(trigger: int, params: Dictionary = {}) -> void:
	if is_triggered(trigger, params):
		var call: Resource = ActionCall.new()
		call.action = self
		call.params = params
		turn_cycle.action_queue.append(call)

func _to_string() -> String:
	return "(" + display_name + ")"

# Actions are intended to implement both the front- and back- end of their function.
# For this reason, the play() method must be a coroutine (usually a pause for an animation 
# to finish).
func play(params: Dictionary) -> void:
	call_deferred("emit_signal", "action_completed")
	yield(self, "action_completed")

func is_triggered(event: int, params: Dictionary) -> bool:
	return false
