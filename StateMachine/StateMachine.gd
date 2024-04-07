extends State
class_name StateMachine

var current_state : Object = null
var previous_state : Object = null

signal state_changed(state)
signal state_changed_recursive(state)

#### ACCESSEURS ####

func set_state(state) -> void:
	if state is String:
		state = get_node_or_null(state)
	
	if current_state != null:
		current_state.exit_state()
	
	if state == current_state:
		return
	
	previous_state = current_state
	current_state = state
	
	if current_state != null:
		current_state.enter_state()
	
	emit_signal("state_changed", current_state)

func get_state() -> Node: 
	return current_state

func get_state_name() -> String : 
	if current_state == null:
		return ""
	else:
		return current_state.name

func get_previous_state() -> Node:
	return previous_state

func get_previous_state_name() -> String : 
	if previous_state == null:
		return ""
	else:
		return previous_state.name


#### BUILT-IN ####

func _ready() -> void:
	connect("state_changed", Callable(self, "_on_state_changed"))
	if state_machine is StateMachine:
		connect("state_changed_recursive", Callable(state_machine, "_on_State_state_changed_recursive"))
	set_to_default_state()

func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

#### VIRTUAL ####

func _ready_state() -> void:
	set_to_default_state()

func exit_state() -> void:
	set_state(null)

func enter_state() -> void:
	set_to_default_state()

#### LOGICS ####

func set_to_default_state() -> void:
	set_state(get_child(0))

func _on_state_changed(_state: Node) -> void:
	emit_signal("state_changed_recursive", current_state)

func _on_State_state_changed_recursive(_state: Node) -> void:
	emit_signal("state_changed_recursive", current_state)



