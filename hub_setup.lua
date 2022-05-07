shell.run('rm', '/git.lua')
shell.run('rm', '/common')
shell.run('wget', 'https://raw.github.com/crazyklatsch/Minecraft_ComputerCraft/main/git.lua')
require('git')
git.get('common')
git.get('hub')
git.get('hub_setup.lua')
local mylist = fs.list('hub/')
for i = 1, #mylist do
    shell.run('rm', mylist[i])
end
shell.run('mv', '/hub/*', '/')
fs.delete('hub')
---@diagnostic disable-next-line: undefined-field
os.reboot()
