require("common.turtle_interface")


local protocol = protocol_turtle_interface

--send expects destination id as first argument and then any number of arguments as message. 
--Usually the first part of the message is a command from the turtle_interface
local function send(...)
    if arg == nil then return false end
    local msg = {table.unpack(arg)}
    local id = tonumber(table.remove(msg, 1))
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
if(arg[0] == "control_turtle" or arg[0]:len() == endpos) then
    send(table.unpack(arg))
end


local control_turtle = {}
control_turtle["send"] = send

return control_turtle