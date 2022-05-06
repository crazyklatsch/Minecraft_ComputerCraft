require('common.turtle_interface')
actions = require('actions')

local protocol = protocol_turtle_interface
local stop_requested = false
local action_queue = {}
local action_queue_active = true

-- Maybe relocate to config file
local allowed_pcids = setmetatable({
    --TODO add MasterMind id
    "13"
    --example:
    --"5",
    --"6",
},
{
    -- Return true if value is existent
    __index = function (t, key)
        for _, val in pairs(t) do
            if val == key then
                return true
            end
        end
        return false
    end
})

--#region commands handling

-- The stop command stops the turtle after finishing current action by emptying the action queue
local function command_stop()
    action_queue = {}
end

-- The pause command pauses the turtle after finishing current action. The next action will not be fetched from the action queue until the continue command is received
local function command_pause()
    action_queue_active = false
end

-- The continue command returnes the turtle to executing actions from the action queue
local function command_continue()
    action_queue_active = true
end

-- The append command appends an action to the action queue
local function command_append_action(...)
    if arg == nil then return false end
    table.insert(action_queue, {table.unpack(arg)})
end

-- The exec command executes an action
local function command_exec_action(...)
    if arg == nil then return false end
    local msg = {table.unpack(arg)}
    local next_action_arguments = table.remove(msg, 1)
    local next_action = table.remove(next_action_arguments, 1)
    local retval = nil
    if(action[next_action] ~= nil) then
        retval = action[next_action](table.unpack(next_action_arguments))
    end
    -- send retval back to pc


end

command["stop"] = command_stop
command["pause"] = command_pause
command["continue"] = command_continue
command["append_action"] = command_append_action
command["exec_action"] = command_exec_action

--#endregion commands

--#region actions

action['calibrate'] = calibrate
action['safe_dig'] = safe_dig
action['dig'] = dig
action['inspect'] = inspect
action['detect'] = detect
action['drop_shit'] = drop_shit
action['move_dir'] = move_dir
action['save_orientation'] = save_orientation
action['move_to_saved_orientation'] = move_to_saved_orientation
action['save_home'] = save_home
action['move_to_home'] = move_to_home
action['mine_vein'] = mine_vein
action['detect_next_ore'] = detect_next_ore
action['move_back'] = move_back
action['move_forward'] = move_forward
action['move_up'] = move_up
action['move_down'] = move_down
action['turn_left'] = turn_left
action['turn_right'] = turn_right
action['turn_around'] = turn_around
action['turn'] = turn
action['face'] = face
action['move_absolute'] = move_absolute
action['move_into_direction'] = move_into_direction
action['move_relative'] = move_relative

--#endregion actions



-- check if rednet is activated
if(not rednet.isOpen()) then
    peripheral.find("modem", rednet.open)
    if(not rednet.isOpen()) then
        print('Could not open rednet. Is a modem attached?')
        return false
    end
end

while not stop_requested do
    -- handle incoming messages
    print("waiting for message ...")
    local pcid, message, protocol = rednet.receive(protocol_turtle_interface, 0)
    -- message is always a table
    if message and allowed_pcids[tostring(pcid)] then
        new_command = table.remove(message, 1)
        if(command[new_command] ~= nil) then
            command[new_command](table.unpack(message))
        end
    end

    -- execute next action from action queue
    if action_queue_active then
        if(#action_queue > 0) then
            local next_action_arguments = table.remove(action_queue, 1)
            local next_action = table.remove(next_action_arguments, 1)
            if(action[next_action] ~= nil) then
                action[next_action](table.unpack(next_action_arguments))
            end
        end
    end

end