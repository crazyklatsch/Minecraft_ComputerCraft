require("common.turtle_interface")

local protocol = protocol_turtle_interface
local id = 0
local msg = {}


rednet.send(id, msg, protocol)