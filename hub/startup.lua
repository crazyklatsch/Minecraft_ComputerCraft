-- set label
os.setComputerLabel('Master PC ' .. os.getComputerID())

-- open rednet
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end