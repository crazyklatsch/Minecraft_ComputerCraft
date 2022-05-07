-- pc status
local state_content = {
    monitor_input = {}, --{monitor, x, y}
    logs = {}, -- {text, log_level, pcid, os.clock()}
    turtle_status = {}, --{"turtled_id" = {turtle_status_table}}
}

-- pseudo singleton pattern
if state == nil then
    state = state_content
end
