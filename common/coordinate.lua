local coordinate_content = {
    0,0,0,
}

local coordinate_metadata = {
    __index = function (coords, key)
        if(key == "new") then
            local result = {0,0,0,}
            setmetatable(result, getmetatable(coords))
            return result
        elseif (key == "copy") then
            local result = {0,0,0,}
            result[1] = coords[1]
            result[2] = coords[2]
            result[3] = coords[3]
            setmetatable(result, getmetatable(coords))
            return result
        elseif (key == "x") then
            return coords[1]
        elseif (key == "y") then
            return coords[2]
        elseif (key == "z") then
            return coords[3]
        else
            return coords[key]
        end
    end,

    __newindex = function (coords, key, value)
        if(key == "x") then
            coords[1] = value
        elseif (key == "y") then
            coords[2] = value
        elseif (key == "z") then
            coords[3] = value
        end
    end,

    __tostring = function(coordinates)
        return ("X "..coordinates[1]..", Y "..coordinates[2]..", Z "..coordinates[3])
    end,

    __add = function (pos1, pos2)
        result = {0,0,0}
        result[1] = pos1[1] + pos2[1]
        result[2] = pos1[2] + pos2[2]
        result[3] = pos1[3] + pos2[3]
        setmetatable(result, getmetatable(pos1))
        return result
    end,

    __sub = function (pos1, pos2)
        result = {0,0,0}
        result[1] = pos1[1] - pos2[1]
        result[2] = pos1[2] - pos2[2]
        result[3] = pos1[3] - pos2[3]
        setmetatable(result, getmetatable(pos1))
        return result
    end
}

--An array of x y z coordinates, can be indexed with x,y,z
local coordinate = setmetatable(coordinate_content, coordinate_metadata)

return coordinate