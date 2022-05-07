require('common.turtle_interface')
require('state')
require('commands')
require('actions')


local stop_requested = false

-- TODO Maybe relocate to config file
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


-- check if rednet is activated
if (not rednet.isOpen()) then
    peripheral.find("modem", rednet.open)
    if (not rednet.isOpen()) then
        print('Could not open rednet. Is a modem attached?')
        return false
    end
end

action.calibrate()

while not stop_requested do
    -- handle incoming messages
    local pcid, message, _ = rednet.receive(protocol.turtle_control, 0)
    -- message is always a table
    if message then -- and allowed_pcids[tostring(pcid)] then
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
