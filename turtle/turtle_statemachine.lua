require('common.turtle_interface')
require('state')
actions = require('actions')

local stop_requested = false
local action_queue = {}
local action_queue_active = true

-- Maybe relocate to config file
local allowed_pcids = setmetatable({
    "12",
    "13",
    --example:
    --"5",
    --"6",
},
    {
    -- Return true if value is existent
    __index = function(t, key)
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
    table.insert(action_queue, { table.unpack(arg) })
end

-- The exec command executes an action
local function command_exec_action(...)
    if arg == nil then return false end
    local next_action_arguments = { table.unpack(arg) }
    local next_action = table.remove(next_action_arguments, 1)
    local retval = nil
    if (action[next_action] ~= nil) then
        retval = action[next_action](table.unpack(next_action_arguments))
    end
    -- TODO send retval back to master pc id
    if state.master_pc_id ~= nil then
        rednet.send(state.master_pc_id, retval, protocol_turtle_control)
    end

end

local function command_set_master_pc_id(...)
    state.master_pc_id = tonumber(arg[1])
    settings.set(settings.master_pc_id, state.master_pc_id)
end

local function command_update_turtle()
    local turtle_setup = require('turtle_setup')
    turtle_setup.setup()
end

command["stop"] = command_stop
command["pause"] = command_pause
command["continue"] = command_continue
command["append_action"] = command_append_action
command["exec_action"] = command_exec_action
command["set_master_pc_id"] = command_set_master_pc_id
command["update_turtle"] = command_update_turtle

--#endregion commands


-- check if rednet is activated
if (not rednet.isOpen()) then
    peripheral.find("modem", rednet.open)
    if (not rednet.isOpen()) then
        print('Could not open rednet. Is a modem attached?')
        return false
    end
end


-- TODO why is it not action.calibrate()
calibrate()
while not stop_requested do
    -- handle incoming messages
    local pcid, message, _ = rednet.receive(protocol_turtle_control, 0)
    -- message is always a table
    if message and allowed_pcids[tostring(pcid)] then
        new_command = table.remove(message, 1)
        if (command[new_command] ~= nil) then
            command[new_command](table.unpack(message))
        end
    end

    -- execute next action from action queue
    if action_queue_active then
        if (#action_queue > 0) then
            local next_action_arguments = table.remove(action_queue, 1)
            local next_action = table.remove(next_action_arguments, 1)
            if (action[next_action] ~= nil) then
                --if action returns false then action_queue_active = false and state = errorstate
                action[next_action](table.unpack(next_action_arguments))
            end
        end
    end

end
