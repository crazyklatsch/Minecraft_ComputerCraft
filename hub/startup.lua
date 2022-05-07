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
local complete_turtle_control = completion.build(
--    { function(shell, index, argument, previous) if argument == "" then return {"id"} end return {} end},
    { completion.choice, 'id' },
    { completion.choice, commands },
    { function(shell, index, argument, previous)
    local prev = previous[index - 1];
    print(prev)
    local complets = {}
    if (prev == 'append_action' or prev == 'exec_action') then
        for _, value in pairs(actions) do
            if string_starts_with(value, argument) then
                table.insert(complets, value:sub(#argument + 1, #value))
            end
        end
    end
    if (prev == 'set_master_pc_id' or prev == 'add_logging_id' or prev == 'remove_logging_id') then
        table.insert(complets, "id")
    end
    return complets
end }
)
shell.setCompletionFunction("control_turtle.lua", complete_turtle_control)
