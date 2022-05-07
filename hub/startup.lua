local completion = require "cc.shell.completion"
require("common.turtle_interface")


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
    { completion.choice, commands }, { completion.choice, actions }
)
shell.setCompletionFunction("control_turtle.lua", complete_turtle_control)
