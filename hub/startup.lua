local completion = require('cc.shell.completion')
require("common.turtle_interface")
require('common.utils')


-- set label
---@diagnostic disable-next-line: undefined-field
os.setComputerLabel('Master PC ' .. os.getComputerID())

-- open rednet
-- cannot differentiate between ender modems and wired modems
-- but opening rednet isnt bad right??
for _, side in pairs({ 'back', 'top', 'left', 'right' }) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end

multishell.launch(_ENV, '/event_listener.lua')
multishell.launch(_ENV, '/monitor.lua')
multishell.setTitle(2, 'event listener')
multishell.setTitle(3, 'monitor')


commands = {}
actions = {}
for k, _ in pairs(command) do
    table.insert(commands, k)
end
for k, _ in pairs(action) do
    table.insert(actions, k)
end
local function complete_turtle_control(shell, index, argument, previous)
    local complets = {}
    if index == 1 and argument == '' then
        table.insert(complets, 'id')
    elseif index == 2 then
        for _, value in pairs(commands) do
            if string_starts_with(value, argument) then
                table.insert(complets, value:sub(#argument + 1))
            end
        end
    elseif index == 3 then
        local prev = previous[index];
        if (prev == 'append_action' or prev == 'exec_action') then
            for _, value in pairs(actions) do
                if string_starts_with(value, argument) then
                    table.insert(complets, value:sub(#argument + 1))
                end
            end
        end
        if (prev == 'set_master_pc_id' or prev == 'add_logging_id' or prev == 'remove_logging_id') then
            table.insert(complets, "id")
        end
    end
    return complets
end
shell.setCompletionFunction("control_turtle.lua", complete_turtle_control)
