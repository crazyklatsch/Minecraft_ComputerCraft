orientation = {
    -- turning right is positive
    north = 1,
    east  = 2,
    south = 3,
    west  = 4,
}
orientation_strings = table_invert(orientation)

direction = {
    invalid = 0,
    front   = 1,
    right   = 2,
    back    = 3,
    left    = 4,
    up      = 5,
    down    = 6,
}
direction_strings = table_invert(direction)

inf = 1e9

junk = {
    'dirt',
    'cobble',
    'gravel',
    'diorite',
    'flint',
    'sand',
    'blackstone',
    'darkstone',
    'coal',
}

print_log_level = log_levels.DEBUG

-- smaller is more important
log_levels = {
    ERROR = 1,
    WARN  = 2,
    INFO  = 3,
    DEBUG = 4,
}

log_level_strings = table_invert(log_levels)

log_level_color = {
    '&e',
    '&1',
    '&0',
    '&8',
}

-- just an array to have easier access to settings via settings.get
conf = {
    master_pc_id = "master_pc_id",
    turtle_move_wait = "turtle_move_wait",
}
