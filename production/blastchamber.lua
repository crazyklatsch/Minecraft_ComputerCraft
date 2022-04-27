
local ITEMS_PER_SLOT = 64
local DEFAULT_BLAST_AMOUNT = 5

local slot_tnt = 1
local slot_enderdust = 2
local slot_singularity = 3
local facing = "front"
local enable = true

local exit_script = false
local blast_amount = DEFAULT_BLAST_AMOUNT;

local function assert_enough_items(slot, amount)
    local old_slot = turtle.getSelectedSlot()
    local existing_amount = turtle.getItemCount(slot)
    return (existing_amount >= amount)
end

local function drop_into_chamber(slot, amount)
    turtle.select(slot)
    if(assert_enough_items(slot, amount)) then
        turtle.dropDown(amount)
    else
        return false
    end
    return true
end

local function place_into_chamber(slot)
    turtle.select(slot)
    if(assert_enough_items(slot, 1)) then
        turtle.placeDown()
    else
        return false
    end
    return true
end

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

local function fill_from_adjacent_inventory(direction, destination_slot)
    face(direction)
    turtle.select(destination_slot)
    local existing_amount = turtle.getItemCount(destination_slot)
    local amount = ITEMS_PER_SLOT - existing_amount
    return turtle.suck(amount)
end

local function refill_all()
    fill_from_adjacent_inventory("back", slot_tnt)
    fill_from_adjacent_inventory("left", slot_enderdust)
    fill_from_adjacent_inventory("right", slot_singularity)
end

local function blast(amount)
    local success = true
    success = success and assert_enough_items(slot_tnt, 1)
    success = success and assert_enough_items(slot_enderdust, amount)
    success = success and assert_enough_items(slot_singularity, amount)

    if(success) then
        drop_into_chamber(slot_enderdust, amount)
        drop_into_chamber(slot_singularity, amount)
        place_into_chamber(slot_tnt)
    end
    return success
end

if(arg[1] ~= nil and type(arg[1]) == type(DEFAULT_BLAST_AMOUNT)) then
    blast_amount = arg[1]
end

while(exit_script ~= true) do
    enable = redstone.getAnalogInput("top")

    if(enable > 0) then
        if(blast(blast_amount) ~= true) then
            refill_all()
        end
    end

    sleep(5)
end