-- set label
---@diagnostic disable-next-line: undefined-field
os.setComputerLabel('Master PC ' .. os.getComputerID())

-- open rednet
-- cannot differentiate between ender modems and wired modems
-- but opening rednet isnt bad right??
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end

multishell.launch(_ENV, '/event_listener.lua')
multishell.launch(_ENV, '/monitor.lua')
multishell.setTitle(2, 'event listener')
multishell.setTitle(3, 'monitor')