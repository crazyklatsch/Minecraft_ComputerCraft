require('common.globals')
require('common.utils')
require('state')

function main()
    -- wrap monitors
    local monitors = { peripheral.find('monitor') }

    --for name, monitor in ipairs(monitors) do
    --    monitor.clear()
    --    monitor.write(name)
    --end

    while true do
        -- handle log printing
        -- this is a log stream implementation,
        -- so changing the print_log_level will only affect future log messages
        local log = table.remove(state.logs, 0)
        if log then
            print_to_screen(monitors[monitor_ids.logger], log[1], log[2], log[3])
        end
        sleep(0.2)
    end
end

function print_to_screen(monitor, msg, log_level, pcid)
    -- TODO horizontal text wrapping -> doesn't it automatically wrap when the monitors size is set?

    local x, y = monitor.getCursorPos()
    local width, height = monitor.getSize()
    if y == height - 1 then
        -- if screen is full goto end
        monitor.scroll(1)
        monitor.setCursorPos(x, 0)
    else
        monitor.setCursorPos(x + 1, 0)
    end

    log(msg, log_level, monitor, pcid)
end

main()