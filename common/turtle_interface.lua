
protocol_turtle_control = "protocol_turtle_control"
protocol_turtle_status = "protocol_turtle_state"

local commands = {
    'stop',
    'pause',
    'continue',
    'append_action',
    'exec_action',
    'set_master_pc_id',
}

local actions = {
    'calibrate',
    'safe_dig',
    'dig',
    'inspect',
    'detect',
    'drop_shit',
    'move_dir',
    'save_orientation',
    'move_to_saved_orientation',
    'save_home',
    'move_to_home',
    'mine_vein',
    'detect_next_ore',
    'move_back',
    'move_forward',
    'move_up',
    'move_down',
    'turn_left',
    'turn_right',
    'turn_around',
    'turn',
    'face',
    'move_absolute',
    'move_into_direction',
    'move_relative',
}

command = {}
for k,v in pairs(commands) do
    command[v] = v
end

action = {}
for k,v in pairs(actions) do
    action[v] = v
end