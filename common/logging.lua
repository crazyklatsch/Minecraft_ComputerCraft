require('common.globals')

function log(msg, log_level, id_pc)
    local log_level = log_level or log_levels.INFO
    if log_level > print_log_level then return end
    print_color('[' .. log_level_color[log_level] .. log_level_strings[log_level] .. '&0] ' .. msg)
    -- TODO rednet send
    -- print message if wanted
    if(id_pc ~= nil) then
        payload = table.pack(log_level, msg)
        rednet.send(id_pc, payload, protocol_logging)
    end
end

