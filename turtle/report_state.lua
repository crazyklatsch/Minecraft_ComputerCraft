require('state')

while true do
    local item_count = 0
    local empty_slot_count = 0
    for slot = 1, 16 do
        local slot_item_count = turtle.getItemCount(slot)
        if slot_item_count > 0 then
            item_count = item_count + slot_item_count
        else
            empty_slot_count = empty_slot_count + 1
        end
    end

    rednet.send(state.master_pc_id, {
        location         = state.pos,
        facing           = state.facing,
        fuel_level       = turtle.getFuelLevel(),
        status           = state.status,
        item_count       = item_count,
        empty_slot_count = empty_slot_count,
    }, protocol_turtle_status)

    sleep(0.5)

end
