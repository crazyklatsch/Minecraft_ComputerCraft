require('common.globals')
require('common.utils')
require('common.logging')
require('state')

function main()
    -- wrap monitors
    local monitors = { peripheral.find('monitor') }

    --for name, monitor in ipairs(monitors) do
    --    monitor.clear()
    --    monitor.write(name)
    --end

    monitors[monitor_ids.logger].clear()
    monitors[monitor_ids.logger].setCursorPos(1, 1)
    monitors[monitor_ids.logger].setTextColor(1)

    while true do
        -- handle log printing
        -- this is a log stream implementation,
        -- so changing the print_log_level will only affect future log messages
        local logg = table.remove(state.logs, 0)
        if logg then
            --log(logg[2], logg[1], term, logg[3])
            print_to_screen(monitors[monitor_ids.logger], logg[1], logg[2], logg[3])
        end
        sleep(0.2)
    end
end

function print_to_screen(monitor, log_level, msg, pcid)
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
