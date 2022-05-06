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
