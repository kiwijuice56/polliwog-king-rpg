class_name Fighter
extends Node

export var display_name: String
export var init_hp: int
export var atk: int

var hp: int
var turn_cycle: Node

func _ready() -> void:
	hp = init_hp
	
	for action in $Actions.get_children():
		add_action(action)

func _to_string() -> String:
	return "{" + display_name + ", hp:" + str(hp) + ", atk:" + str(atk) + "}"

func take_damage(damage: int, source: Fighter) -> void:
	hp -= damage
	turn_cycle.emit_signal("event_triggered", Event.DAMAGE_TAKEN, {"defender": self, "attacker": source})

func deal_damage(target: Fighter) -> int:
	turn_cycle.emit_signal("event_triggered", Event.DAMAGE_DEALT, {"attacker": self, "defender": target})
	return atk

func add_action(action: Node) -> void:
	if not action.is_inside_tree():
		$Actions.add_child(action)
	action.action_owner = self
