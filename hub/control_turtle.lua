require("common.turtle_interface")


local protocol = protocol_turtle_interface

--send expects id as number and msg as primitive non-function type
local function send(id, msg)
    if(not rednet.isOpen()) then
        peripheral.find("modem", rednet.open)
        if(not rednet.isOpen()) then
            print('Could not open rednet. Is a modem attached?')
            return false
        end
    end
    rednet.send(id, msg, protocol)
    return true
end

local _,endpos = arg[0]:find("control_turtle.lua")
if(arg[0] == "turtle_interface" or arg[0]:len() == endpos) then
    local msg = {table.unpack(arg)}
    local id = table.remove(msg, 1)
    send(id, msg)
end


local control_turtle = {}
control_turtle["send"] = send

return control_turtle