require('common.globals')

-- terminal is optional, default => term
-- pcid is optional, default will not show
function log(msg, log_level, terminal, pcid)
    local log_level = log_level or log_levels.INFO
    local terminal = terminal or term

    local message = '[' .. log_level_color[log_level] .. log_level_strings[log_level] .. '&0]'
    -- append pcid if available
    if pcid then
        message = message .. '[' .. pcid .. ']'
    end
    message = message .. ' ' .. msg
    
    -- send message to list of logging_ids
    local logging_ids = settings.get(config.logging_ids)
    if not logging_ids then return end
    for _, id in ipairs(logging_ids) do
        payload = table.pack(log_level, msg)
        rednet.send(id, payload, protocol.logging)
    end

    -- print locally
    if log_level > print_log_level then return end
    print_color(terminal, message)
end

