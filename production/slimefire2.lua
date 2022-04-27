
local ITEMS_PER_SLOT = 64

local slot_fern = 1
local slot_leaf = 2
local slot_leaf_out = 3
local slot_junk = 4
local slot_probe = 5
local slot_first_storage = 6
local slot_last_storage = 16

local items_in_pipe = 0
local facing = "front"
local enable = true

local side_cutting = "back"
local side_output = "front"
local side_grill = "right"
local side_chute = "left"


local function face(direction)
    if(direction == "back") then
        if(facing == "right") then
            turtle.turnRight()
        elseif(facing == "left") then
            turtle.turnLeft()
        elseif(facing == "front") then
            turtle.turnRight()
            turtle.turnRight()
        end
    elseif(direction == "right") then
        if(facing == "back") then
            turtle.turnLeft()
        elseif(facing == "left") then
            turtle.turnRight()
            turtle.turnRight()
        elseif(facing == "front") then
            turtle.turnRight()
        end
    elseif(direction == "left") then
        if(facing == "back") then
            turtle.turnRight()
        elseif(facing == "right") then
            turtle.turnLeft()
            turtle.turnLeft()
        elseif(facing == "front") then
            turtle.turnLeft()
        end
    elseif(direction == "front") then
        if(facing == "back") then
            turtle.turnLeft()
            turtle.turnLeft()
        elseif(facing == "right") then
            turtle.turnLeft()
        elseif(facing == "left") then
            turtle.turnRight()
        end
    else
        return false
    end
    facing = direction
    return true
end

local function get_free_storage()
    local free = 0
    for slot=slot_first_storage, slot_last_storage do 
        free = free + (ITEMS_PER_SLOT - turtle.getItemCount(slot))
    end
    return free
end

local function suck_grill()
    success = true
    face(side_grill)
    turtle.select(slot_first_storage)
    while(success and (get_free_storage() >= ITEMS_PER_SLOT)) do
        success = turtle.suck()
    end
end

local function dump_storage()
    face(side_output)
    for slot=slot_first_storage, slot_last_storage do
        turtle.select(slot)
        turtle.drop()
    end
end

local function dump_leaf_out()
    if(turtle.getItemCount(slot_leaf_out) > 0) then
        face(side_chute)
        turtle.select(slot_leaf_out)
        turtle.drop()
    end
end

local function convert_fern_to_leaf()
    local loopback_amount = (ITEMS_PER_SLOT - turtle.getItemCount(slot_leaf))
    local amount = turtle.getItemCount(slot_fern)
    local max_amount = math.floor(((ITEMS_PER_SLOT - turtle.getItemCount(slot_leaf_out)) + loopback_amount) / 2)
    if(max_amount < amount) then
        amount = max_amount
    end

    face(side_cutting)
    turtle.select(slot_fern)
    turtle.drop(amount)
    sleep(1 + 0.6 * amount)
    turtle.select(slot_leaf) --Overflows into slot_leaf_out
    turtle.suck()
    turtle.suck()
end

local function convert_leaf_to_fern()
    local success = true
    local max_amount = ITEMS_PER_SLOT - turtle.getItemCount(slot_fern)
    if(turtle.getItemCount(slot_leaf) > 0) then
        turtle.select(slot_leaf)
        turtle.dropDown(max_amount)
        sleep(4)
        turtle.select(slot_fern)
        turtle.suckDown()
    else
        success = false
    end
    return success
end

local function main()
    while(enable) do
        convert_leaf_to_fern()
        suck_grill()
        convert_fern_to_leaf()
        suck_grill()
        dump_leaf_out()
        suck_grill()
        dump_storage()
        suck_grill()
    end
end

main()