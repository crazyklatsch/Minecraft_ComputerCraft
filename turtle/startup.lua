-- set label
os.setComputerLabel('Turtle ' .. os.getComputerID())

-- open rednet
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end