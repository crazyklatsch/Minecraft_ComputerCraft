local coordinate = require("common.coordinate")

local state_content = {
    facing = 1,
    pos = coordinate.new,
    state = 0,
    queue = {},
}

local state_metadata = {
    __tostring = function (state)
        local output = "Facing: "
        if(state.facing == 1) then
            output = output.."north"
        elseif(state.facing == 2) then
            output = output.."east"
        elseif(state.facing == 3) then
            output = output.."south"
        elseif(state.facing == 4) then
            output = output.."west"
        end
        output = (output.."\nAt "..'X '..state.pos.x..', Y '..state.pos.y..', Z '..state.pos.z)
        return output
    end
}

local state = setmetatable(state_content, state_metadata)

return state