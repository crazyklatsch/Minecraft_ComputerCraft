require('common.turtle_interface')
actions = require('actions')

--#region commands handling

-- The stop command stops the turtle after finishing current action and empties the action queue
local function command_stop()
    
end

-- The pause command pauses the turtle after finishing current action. The next action will not be fetched from the action queue until the continue command is received
local function command_pause()

end

-- The continue command returnes the turtle to executing actions from the action queue
local function command_continue()
    
end

-- The append command appends an action to the action queue
local function command_append_action(...)
    if arg == nil then return false end
    local msg = {table.unpack(arg)}
end

-- The exec command executes an action
local function command_exec_action(...)
    if arg == nil then return false end
    local msg = {table.unpack(arg)}
end

command["stop"] = command_stop
command["pause"] = command_pause
command["continue"] = command_continue
command["append_action"] = command_append_action
command["exec_action"] = command_exec_action

--#endregion commands

local protocol = protocol_turtle_interface
local stop_requested = false


-- check if rednet is activated
if(not rednet.isOpen()) then
    peripheral.find("modem", rednet.open)
    if(not rednet.isOpen()) then
        print('Could not open rednet. Is a modem attached?')
        return false
    end
end

while not stop_requested do
    pcid, message, protocol = rednet.receive(protocol_turtle_interface)
    -- message is always a table
    if message then
        new_command = table.remove(message, 1)
        if(command[new_command] ~= nil) then
            command[new_command](message)
        end
    end
end