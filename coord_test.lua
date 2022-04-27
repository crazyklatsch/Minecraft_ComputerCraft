coordinate = require('common.coordinate')

local c = coordinate.new
print(c)
c.x = 3
print(c)
local t = c.copy
print(t)