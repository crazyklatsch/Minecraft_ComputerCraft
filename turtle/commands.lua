require('common.turtle_interface')
require('common.logging')
require('common.globals')

local com = {}

-- The stop command stops the turtle after finishing current action by emptying the action queue
function com.stop()
    log('Emptying action queue', log_levels.DEBUG)
    action_queue = {}
end

-- The pause command pauses the turtle after finishing current action. The next action will not be fetched from the action queue until the continue command is received
function com.pause()
    log('Pausing action queue', log_levels.DEBUG)
    action_queue_active = false
end

-- The continue command returnes the turtle to executing actions from the action queue
function com.continue()
    log('Continuing action queue', log_levels.INFO)
    action_queue_active = true
end

-- The append command appends an action to the action queue
function com.append_action(...)
    if arg == nil then
        log('Trying to append nil action. skipping...', log_levels.WARN)
        return false
    end
    log('Appending action', log_levels.DEBUG)
    table.insert(action_queue, { table.unpack(arg) })
end

-- The exec command executes an action
function com.exec_action(...)
    if arg == nil then return false end
    local next_action_arguments = { table.unpack(arg) }
    local next_action = table.remove(next_action_arguments, 1)
    local retval = nil
    if (action[next_action] ~= nil) then
        log('Executing action', log_levels.DEBUG)
        retval = action[next_action](table.unpack(next_action_arguments))
    end
    -- TODO send retval back to master pc id
    if state.master_pc_id ~= nil then
        rednet.send(state.master_pc_id, retval, protocol.turtle_control)
    end

end

function com.set_master_pc_id(...)
    log('Setting master pc id', log_levels.INFO)
    state.master_pc_id = tonumber(arg[1])
    settings.set(settings.master_pc_id, state.master_pc_id)
end

function com.update_turtle()
    log('Updating turtle', log_levels.INFO)
    local turtle_setup = require('turtle_setup')
    turtle_setup.setup()
end

function com.add_logging_id(...)
    log('Adding logging id', log_levels.INFO)
    local logging_ids = settings.get(config.logging_ids)
    -- arg parse check
    if not arg[1] or tonumber(arg[1]) then  return end
    -- exist check
    for _, id in ipairs(logging_ids) do
        if id == arg[1] then
            log('ID already subscribed to logging', log_levels.WARN)
            return
        end
    end
    -- overwrite settings
    table.insert(logging_ids, tonumber(arg[1]))
    settings.set(config.logging_ids, logging_ids)
end

function com.remove_logging_id(...)
    log('Removing logging id', log_levels.INFO)
    local logging_ids = settings.get(config.logging_ids)
    -- arg parse check
    if not arg[1] or tonumber(arg[1]) then return end
    -- remove value from table
    for i, id in ipairs(logging_ids) do
        if id == arg[1] then
            table.remove(logging_ids, i)
            -- overwrite settings
            settings.set(config.logging_ids, logging_ids)
            -- should only be there once -> can immediately return
            return
        end
    end
end

for key, value in pairs(com) do
    if (command[key] ~= nil) then
        command[key] = value
    else
        log('Trying to add command not defined in turtle_interface', log_levels.DEBUG)
    end
end
