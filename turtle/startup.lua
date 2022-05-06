-- set label
os.setComputerLabel('Turtle ' .. os.getComputerID())

local default_pc_master_id = 13

-- create file for master pc id if not present
if not fs.exists('/master_pc_id') then
    file = fs.open('/master_pc_id', 'w')
    file.write(default_pc_master_id)
    file.close()
end


multishell.launch(getfenv(), '/turtle_statemachine.lua')
multishell.launch(getfenv(), '/report_state.lua')
multishell.setTitle(2, 'statemachine')
multishell.setTitle(3, 'report_state')
