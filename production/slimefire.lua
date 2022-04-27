-- should start towards fire

local fern_blue = 1
local fern_pink = 2
local fern_green = 1

local fern_blue_leaf = fern_blue + 4
local fern_pink_leaf = fern_pink + 4
local fern_green_leaf = 2


-- uses leaf
local function throw_fire(slot)
    turtle.select(slot)
    local amount = turtle.getItemCount(slot)
    turtle.drop(2)
    sleep(2)
    turtle.select(1)
    turtle.suck()
    turtle.select(slot)
end

-- uses fern
local function duplicate(slot)
    turtle.select(slot)
    turtle.drop(1)
    sleep(3)
    turtle.select(slot)
    turtle.suck()
    turtle.select(slot - 4)
end

local function throw_belt(slot, amount)
    turtle.select(slot)
    turtle.drop(amount)
end

local function multiply_all()
    --turtle.turnLeft()
    for current_fern = 1, 3 do
        turtle.select(current_fern)
        -- repeat until there are enough leafs
        while turtle.getItemCount(current_fern + 4) < 60 and turtle.getItemCount(current_fern) < 60 do
            -- duplicate as long as there are items
            while turtle.getItemCount(current_fern + 4) < 63 and turtle.getItemCount(current_fern) > 2 do
                duplicate(current_fern)
            end
            turtle.turnLeft()
            -- throw in fire as long as there are items
            while turtle.getItemCount(current_fern) < 63 and turtle.getItemCount(current_fern + 4) > 2 do
                throw_fire(current_fern + 4)
            end
            turtle.turnRight()
        end
    end
    --turtle.turnRight()
end

-- checks stacks from slot 3 to 16, returns number of stacks
local function has_leafs_left()
    local stacks = 0
    for i = 3, 16 do
        turtle.select(i)
        if turtle.getItemCount() > 0 then
            stacks = stacks + 1
        end
    end
    return stacks
end

-- checks inventory content from slot 3 to 16 and returns first available
local function get_next_stack()
    for i = 3, 16 do
        turtle.select(i)
        if turtle.getItemCount() > 0 then
            return i
        end
    end
    return 0
end

local function has_space()
    for i = 3, 16 do
        turtle.select(i)
        if turtle.getItemCount() == 0 then
            return true
        end
    end
    return false
end

local function main()
    while true do
        if redstone.getAnalogInput('right') > 0 and has_leafs_left() > 0 then
            local slot = get_next_stack()
            if slot ~= 0 then
                turtle.select(slot)
                turtle.dropUp()
            end
        elseif has_space() then
            -- duplicate as long as there are items
            turtle.turnLeft()
            while turtle.getItemCount(fern_green) > 2 do
                duplicate(fern_green)
            end
            turtle.turnRight()
            -- throw in fire as long as there are items
            while turtle.getItemCount(fern_green) < 63 do
                throw_fire(fern_green_leaf)
            end
        else
            sleep(1)
        end
    end
end

main()
