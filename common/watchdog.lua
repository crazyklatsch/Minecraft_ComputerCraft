require('common.globals')
require('common.logging')

local path_to_program = arg[1]
if path_to_program == nil then
    log("Watchdog got nil program.", log_levels.ERROR)
    return -1
end

while true do
    local retval = shell.run(path_to_program)
    log("Program: "..path_to_program..' exited ('..tostring(retval)..')', log_levels.ERROR)
end