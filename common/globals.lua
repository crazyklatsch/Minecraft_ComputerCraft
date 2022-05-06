orientation = {
    -- turning right is positive
    north = 1,
    east  = 2,
    south = 3,
    west  = 4,
}

direction = {
    invalid = 0,
    front   = 1,
    right   = 2,
    back    = 3,
    left    = 4,
    up      = 5,
    down    = 6,
}

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

print_log_level = log_levels.WARN

-- smaller is more important
log_levels = {
    ERROR = 1,
    WARN  = 2,
    INFO  = 3,
}

log_level_strings = table_invert(log_levels)

log_level_color = {
    '&e',
    '&1',
    '&8',
}

-- just an array to have easier access to settings via settings.get
settings = {
    master_pc_id = "master_pc_id",
    turtle_move_wait = "turtle_move_wait",
}
