require('common.globals')

-- set label
os.setComputerLabel('Turtle ' .. os.getComputerID())


-- create default settings values
-- they are not overwritten if they have already been set
settings.define(conf.master_pc_id, { default = 13, type = "number" })
settings.define(conf.turtle_move_wait, { default = 1.0, type = "number" })


multishell.launch(_ENV, '/turtle_statemachine.lua')
multishell.launch(_ENV, '/report_state.lua')
multishell.setTitle(2, 'state manager')
multishell.setTitle(3, 'status report')
