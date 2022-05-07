local function setup()
    shell.run('rm', '/git.lua')
    shell.run('rm', '/common')
    shell.run('wget', 'https://raw.github.com/crazyklatsch/Minecraft_ComputerCraft/main/git.lua')
    require('git')
    git.get('common')
    git.get('turtle')
    git.get('turtle_setup.lua')

    local mylist = fs.list('turtle/')
    for i = 1, #mylist do
        shell.run('rm', mylist[i])
    end
    shell.run('mv', '/turtle/*', '/')
    fs.delete('turtle')
    ---@diagnostic disable-next-line: undefined-field
    os.reboot()
end

local _,endpos = arg[0]:find("turtle_setup.lua")
if(arg[0] == "turtle_setup" or arg[0]:len() == endpos) then
    setup()
end
