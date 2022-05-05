require('common.globals')

-- check if rednet is activated
if not rednet.isOpen() then return end

while true do
    local message = rednet.receive(protocol_name)
    if message then
        -- do stuff to message
    end
end