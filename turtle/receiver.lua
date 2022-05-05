require('common.turtle_interface')
actions = require('actions')

-- check if rednet is activated
if not rednet.isOpen() then return end

while true do
    pcid, message, protocol = rednet.receive(protocol_turtle_interface)
    -- message is always a table
    if message then
        if message[1] == command.protocol_turtle_interface then
            table.insert(actions.state, ({message[2], }))
        elseif message[1] == command.stop then

        elseif message[1] == command.pause then

        end
    end
end