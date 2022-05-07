require('common.globals')
require('state')

while true do
    event = { os.pullEvent() }
    if event[1] == 'rednet_message' then
        local sender = event[2]
        local message = event[3]
        local prot = event[4]

        -- handle protocols
        if prot == protocol.logging then
            table.insert(state.logs, { message[1], message[2], sender, os.clock() })

        elseif prot == protocol.turtle_status then
            --{"turtled_id" = {turtle_status_table}}
            state.turtle_status[event[2]] = event[3]
        end
    elseif event[1] == 'monitor_touch' then
        -- handle touch
        table.insert(state.monitor_input, { monitor = event[2], x = event[3], y = event[4] })
    end
end
