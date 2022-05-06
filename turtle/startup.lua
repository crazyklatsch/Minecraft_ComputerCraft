-- set label
os.setComputerLabel('Turtle ' .. os.getComputerID())

local default_pc_master_id = 13

-- create file for master pc id if not present
if not fs.exists('/master_pc_id') then
    file = fs.open('/master_pc_id', 'w')
    file.write(default_pc_master_id)
    file.close()
end


multishell.launch({}, '/turtle_statemachine.lua')
multishell.launch({}, '/report.lua')
multishell.setTitle(1, 'statemachine')
multishell.setTitle(2, 'report')
