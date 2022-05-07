require('common.globals')
require('common.utils')
require('common.logging')
require('common.watchdog')

-- set label
---@diagnostic disable-next-line: undefined-field
os.setComputerLabel('Turtle ' .. os.getComputerID())


-- create default settings values
-- they are not overwritten if they have already been set
settings.define(config.master_pc_id, { default = 13, type = "number" })
settings.define(config.turtle_move_wait, { default = 1.0, type = "number" })
settings.define(config.logging_ids, { default = { settings.get(config.master_pc_id) }, type = "table" })


--local id_statemachine = multishell.launch(_ENV, '/common/watchdog.lua', '/turtle_statemachine.lua')
local id_statemachine = multishell.launch(_ENV, '/turtle_statemachine.lua')
local id_reportstate = multishell.launch(_ENV, '/report_state.lua')
multishell.setTitle(id_statemachine, 'state manager')
multishell.setTitle(id_reportstate, 'status report')

log('Starting up', log_levels.INFO)
