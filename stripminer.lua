require('actions')

calibrate()
save_home()
for i = 1, 100 do
    save_orientation()
    mine_vein()
    move_to_saved_orientation()
    safe_dig()
    move_forward()
    if i % 10 == 0 then
        drop_shit()
    end
end
move_to_home()