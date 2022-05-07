require('common.globals')
require('common.utils')
require('common.turtle_interface')
require('state')
require('log')
coordinate = require('common.coordinate')

local act = {}
local saved_positions = {}


-- turning right is positive
function act.get_new_orientation(turns)
    return ((state.facing + turns - 1) % 4 + 1)
end

function act.calibrate()
    x, y, z = gps.locate()
    if not x or not y or not z then
        log('No gps available', log_levels.ERROR)
        return false
    end
    -- try to find adjacent block
    local turns
    for i = 0, 3 do
        -- lua has weird scoping
        -- using turns in the for loop directly creates new varilable for this block
        turns = i
        -- if the block in front is free break loop
        if not turtle.detect() then break end
        turtle.turnRight()
    end
    -- if there is still a block in front you can force break it
    if turtle.detect() then
        -- force break??
        log('Lacking space for calibration', log_levels.ERROR)
        return false
    end

    turtle.forward()
    local nx, _, nz = gps.locate()
    if nx == x - 1 then state.facing = orientation.west end
    if nx == x + 1 then state.facing = orientation.east end
    if nz == z + 1 then state.facing = orientation.south end
    if nz == z - 1 then state.facing = orientation.north end
    -- move to original position
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    turtle.turnLeft()
    act.turn_left(turns)
    state.pos.x = x
    state.pos.y = y
    state.pos.z = z
    log('Calibrated to ' .. state.pos.x .. ', ' .. state.pos.y .. ', ' .. state.pos.z, log_levels.INFO)
    log('Facing ' .. state.facing, log_levels.INFO)
    return true
end

function act.safe_dig(dir)
    local dir = dir or direction.front
    if dir == direction.invalid then return false end

    if act.detect(dir) then
        -- dont mine other turtles
        if act.inspect(dir)[2].name:lower():find('computer') then
            log('Found turtle when digging', log_levels.WARN)
            return false
        end
    end

    return act.dig(dir)
end

function act.inspect(dir)
    -- [1] -> bool is_there_block
    -- [2].name -> name of block
    local dir = dir or direction.front
    if dir == direction.invalid then return false end

    log('Inspecting ' .. direction_strings[dir], log_levels.DEBUG)
    if dir == direction.up then return ({ turtle.inspectUp() }) end
    if dir == direction.down then return ({ turtle.inspectDown() }) end
    if dir == direction.front then return ({ turtle.inspect() }) end

    local data
    if dir == direction.left then
        act.turn_left()
        data = ({ turtle.inspect() })
        act.turn_right()
    elseif dir == direction.right then
        act.turn_right()
        data = ({ turtle.inspect() })
        act.turn_left()
    else
        -- back
        act.turn_around()
        data = ({ turtle.inspect() })
        act.turn_around()
    end
    return data
end

function act.detect(dir)
    local dir = dir or direction.front
    if dir == direction.invalid then return false end

    log('Detecting ' .. direction_strings[dir], log_levels.DEBUG)
    if dir == direction.up then return turtle.detectUp() end
    if dir == direction.down then return turtle.detectDown() end
    if dir == direction.front then return turtle.detect() end

    local is_block = false
    if dir == direction.left then
        act.turn_left()
        is_block = turtle.detect()
        act.turn_right()
    elseif dir == direction.right then
        act.turn_right()
        is_block = turtle.detect()
        act.turn_left()
    else
        -- back
        act.turn_around()
        is_block = turtle.detect()
        act.turn_around()
    end
    return is_block
end

function act.dig(dir, account_for_gravity_blocks)
    local dir = dir or direction.front
    local account_for_gravity_blocks = account_for_gravity_blocks or true
    if dir == direction.invalid then return false end

    log('Digging ' .. direction_strings[dir], log_levels.DEBUG)

    local success = false
    if dir == direction.up then success = turtle.digUp() end
    if dir == direction.down then success = turtle.digDown() end
    if dir == direction.front then success = turtle.dig() end

    if dir == direction.left then
        act.turn_left()
        success = turtle.dig()
        act.turn_right()
    elseif dir == direction.right then
        act.turn_right()
        success = turtle.dig()
        act.turn_left()
    else
        -- back
        act.turn_around()
        success = turtle.dig()
        act.turn_around()
    end
    -- recursively call dig until all gravity blocks are gone
    if act.detect(dir) and account_for_gravity_blocks then act.dig(dir, account_for_gravity_blocks) end
    return success
end

function act.drop_shit()
    local detail
    for i = 1, 16 do
        detail = turtle.getItemDetail(i)
        if detail then
            for _, item in pairs(junk) do
                if detail.name:lower():find(item) then
                    turtle.select(i)
                    turtle.refuel()
                    turtle.drop()
                end
            end
        end
    end
    turtle.select(1)
end

function act.transfer_to_inventory()
    log('Transferring inventory', log_levels.DEBUG)
    for i = 1, 16 do
        turtle.select(i)
        if not turtle.drop() then
            log('Chest full', log_levels.WARN)
            return false
        end
    end
    turtle.select(1)
    return true
end

function act.move_dir(dir)
    local dir = dir or direction.front
    if dir == direction.invalid then return false end

    if dir == direction.up then return act.move_up() end
    if dir == direction.down then return act.move_down() end
    if dir == direction.front then return act.move_forward() end

    local success = false
    if dir == direction.left then
        act.turn_left()
        success = act.move_forward()
        act.turn_right()
    elseif dir == direction.right then
        act.turn_right()
        success = act.move_forward()
        act.turn_left()
    else
        -- back
        act.turn_around()
        success = act.move_forward()
        act.turn_around()
    end
    return success
end

-- saves current position and orientation, returns index of position
function act.save_position()
    log('Saving position @' .. state.pos.x .. '/' .. state.pos.y .. '/' .. state.pos.z, log_levels.DEBUG)
    table.insert(saved_positions, { state.pos.copy, state.facing })
    return #saved_positions
end

function act.move_to_saved_position(id)
    log('Moving to saved position', log_levels.DEBUG)
    act.move_absolute(table.unpack(saved_positions[id][1]))
    act.face(saved_positions[id][2])
end

function act.clear_saved_positions()
    log('Clearing saved positions', log_levels.DEBUG)
    saved_positions = {}
end

function act.mine_vein()
    local positions = {}
    table.insert(positions, state.pos.copy)
    while #positions > 0 do
        local dir = act.detect_next_ore()
        -- if no ore is found at current pos move back
        if dir == direction.invalid then
            log('No ore found, moving back', log_levels.DEBUG)
            local coord = table.remove(positions)
            act.move_absolute(table.unpack(coord))
        else
            log('Ore found (' .. direction_strings[dir] .. ')', log_levels.INFO)
            act.safe_dig(dir)
            table.insert(positions, state.pos.copy)
            act.move_dir(dir)
        end
    end
end

function act.detect_next_ore()
    log('Trying to find ore', log_levels.DEBUG)
    local ore_name = 'ore' --'cobble'
    -- check up and down
    if act.detect(direction.up) and act.inspect(direction.up)[2].name:lower():find(ore_name) then return direction.up end
    if act.detect(direction.down) and act.inspect(direction.down)[2].name:lower():find(ore_name) then return direction.down end
    -- check all sides
    for i = 1, 4 do
        if act.detect(direction.front) and act.inspect(direction.front)[2].name:lower():find(ore_name) then return direction.front end
        act.turn_left()
    end
    return direction.invalid
end

function act.turn_around()
    act.turn_left(2)
end

function act.move_back()
    -- moves turtle backwards once (while keeping orientation)
    act.turn_around()
    act.move_forward()
    act.turn_around()
end

function act.move_forward(amount, force)
    log('Moving forward for ' .. amount .. ' blocks', log_levels.DEBUG)
    force = force or false
    amount = amount or 1
    for i = 1, amount do
        if force then act.safe_dig(direction.front) end
        local success = turtle.forward()
        if not success then
            -- try to wait until block is no longer obstructed
            sleep(settings.get(settings.turtle_move_wait))
            success = turtle.forward()
            -- return false if move not possible
            if not success then
                log('Could not move forward', log_levels.ERROR)
                return false
            end
        end
        -- update location
        if state.facing == orientation.north then state.pos.z = state.pos.z - 1 end
        if state.facing == orientation.east then state.pos.x = state.pos.x + 1 end
        if state.facing == orientation.south then state.pos.z = state.pos.z + 1 end
        if state.facing == orientation.west then state.pos.x = state.pos.x - 1 end
    end
    return true
end

function act.move_up(amount, force)
    force = force or false
    amount = amount or 1
    for i = 1, amount do
        if force then act.safe_dig(direction.up) end
        local success = turtle.up()
        if not success then
            -- try to wait until block is no longer obstructed
            sleep(settings.get(settings.turtle_move_wait))
            success = turtle.up()
            -- return false if move not possible
            if not success then
                log('Could not move upwards', log_levels.ERROR)
                return false
            end
        end
        -- update location
        state.pos.y = state.pos.y + 1
    end
    return true
end

function act.move_down(amount, force)
    force = force or false
    amount = amount or 1
    for i = 1, amount do
        if force then act.safe_dig(direction.down) end
        local success = turtle.down()
        if not success then
            -- try to wait until block is no longer obstructed
            sleep(settings.get(settings.turtle_move_wait))
            success = turtle.down()
            -- return false if move not possible
            if not success then
                log('Could not move down', log_levels.ERROR)
                return false
            end
        end
        -- update location
        state.pos.y = state.pos.y - 1
    end
    return true
end

function act.turn_left(turns)
    turns = turns or 1
    act.turn(-1 * turns)
end

function act.turn_right(turns)
    turns = turns or 1
    act.turn(turns)
end

function act.turn(turns)
    if turns > 0 then
        log('Turning right ' .. turns .. ' times', log_levels.DEBUG)
        for i = 1, turns do
            turtle.turnRight()
        end
    else
        log('Turning left ' .. turns .. ' times', log_levels.DEBUG)
        for i = 1, -1 * turns do
            turtle.turnLeft()
        end
    end
    state.facing = act.get_new_orientation(turns)
end

function act.face(side)
    log('Facing ' .. orientation_strings[side], log_levels.DEBUG)
    -- check boundaries
    if side < 1 or side > 4 then return end

    if state.facing == side then return end
    if math.abs(state.facing - side) == 2 then act.turn_around() end
    if side == act.get_new_orientation(1) then act.turn_right() end
    if side == act.get_new_orientation(-1) then act.turn_left() end
end

function act.move_absolute(nx, ny, nz, force)
    -- stops in place when move was not possible
    if (nx == nil or ny == nil or nz == nil) then return false end
    return act.move_relative(nx - state.pos.x, ny - state.pos.y, nz - state.pos.z, force)
end

function act.move_into_direction(direction, amount, force)
    if (direction == nil) then return false end
    amount = amount or 1
    if direction == orientation.north then return act.move_relative(0, 0, -1 * amount, force) end
    if direction == orientation.east then return act.move_relative(amount, 0, 0, force) end
    if direction == orientation.south then return act.move_relative(0, 0, amount, force) end
    if direction == orientation.west then return act.move_relative(-1 * amount, 0, 0, force) end
    return false
end

function act.move_relative(dx, dy, dz, force)
    log('Moving relative to ' .. dx .. '/' .. dy .. '/' .. dz, log_levels.DEBUG)
    if (dx == nil or dy == nil or dz == nil) then return false end
    -- stops in place when move was not possible
    local success = false
    force = force or false
    -- adjust height
    if dy > 0 then success = act.move_up(dy, force)
    elseif dy == 0 then success = true
    else success = act.move_down(-1 * dy, force) end
    if not success then return success end
    -- adjust x
    if dx > 0 then
        act.face(orientation.east)
        success = act.move_forward(dx, force)
    elseif dx == 0 then success = true
    else
        act.face(orientation.west)
        success = act.move_forward(-1 * dx, force)
    end
    if not success then return success end
    -- adjust z
    if dz > 0 then
        act.face(orientation.south)
        success = act.move_forward(dz, force)
    elseif dz == 0 then success = true
    else
        act.face(orientation.north)
        success = act.move_forward(-1 * dz, force)
    end
    return success
end

for key, value in pairs(act) do
    if (action[key] ~= nil) then
        action[key] = value
    end
end
