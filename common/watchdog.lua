require('common.globals')
require('common.logging')

path_to_program = arg[1]

while true do
    local retval = shell.run(path_to_program)
    log("Program: "..path_to_program..' exited ('..tostring(retval)..')', log_levels.ERROR)
end