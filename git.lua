-- git api
-- This function gets a file or folder from the repo crazyklatsch/Minecraft_ComputerCraft

local user = "crazyklatsch"
local repo = "Minecraft_ComputerCraft"
local branch = "main"

git = {}
function git.get(file)
    -- check arguments
    if (file == nil) then
        print("Usage: git get path/to/[filename.lua]")
        return false
    end

    print("Connecting to Github")
    download_recursive(file)
    print("Download completed")
    return true
end

function download_file(path, url, name)
    print("Downloading "..path)
    -- extract only dir path from path
    local dir_path = path:gmatch('([%w%_%.% %-%+%,%;%:%*%#%=%/]+)/'..name..'$')()
    if dir_path ~= nil then
        if not fs.exists(dir_path) then
            fs.makeDir(dir_path)
        end
    end
    local file = fs.open(path,"w")
    file.write(git_hub_direct_download_helper(url))
    file.close()
end

function git_hub_direct_download_helper(url)
    local from = '<table'
    local to = '</table>'
    local line_start = '<td id="LC'
    local line_end = '</td>'
    local response = http.get(url)
    if response then
        local git_site = response.readAll()

        -- get table where script resides
        local i = git_site:find(from)
        local _,j = git_site:find(to)
        git_site = git_site:sub(i,j)

        -- get script lines from LC tag
        script = ''
        for line in git_site:gmatch(line_start..'.-'..line_end) do
            line = line:gsub('<.->', '')
            if line == '\n' then
                script = script..'\n'
            else
                script = script..line..'\n'
            end
        end

        -- replace weird characters
        script = script:gsub('&quot;', '"')
        script = script:gsub('&gt;', '>')
        script = script:gsub('&lt;', '<')
        script = script:gsub('&#39;', '\'')
        script = script:gsub('&amp;', '&')
        
        return script
    else
        print('Cannot find script')
        return ''
    end
end

function get_git_folder_content(folder_path)
    local type, path, name = {}, {}, {}
    -- read dir tree via git api
    local url = "https://api.github.com/repos/"..user.."/"..repo.."/contents/"..folder_path
    local response = http.get(url)
    if response then
        response = response.readAll()
        if response ~= nil then
            for str in response:gmatch('"type":"(%w+)"') do table.insert(type, str) end
            for str in response:gmatch('"path":"([^\"]+)"') do table.insert(path, str) end
            for str in response:gmatch('"name":"([^\"]+)"') do table.insert(name, str) end
        end
    else
        print("Error: Can't resolve URL")
        print(url)
        error()
    end
    return type, path, name
end

-- can also be called on file and will just download it
function download_recursive(folder_path)
    local type, path, name = get_git_folder_content(folder_path)
    for i, data in pairs(type) do
        if data == "dir" then
            -- handle dirs
            -- list dir content recursively
            download_recursive(path[i])
        elseif data == "file" then
            -- handle files
            download_file(path[i], 'https://github.com/'..user..'/'..repo..'/blob/'..branch..'/'..path[i], name[i])
            -- raw link works better but is delayed 5 minutes
            --"https://raw.github.com/"..user.."/"..repo.."/"..branch.."/"..path[i]
        end
    end
end

if(arg[0] == "git") then
    if(arg[1] == "get" or arg[1] == "clone" or arg[1] == "gut") then
        git.get(arg[2])
    end
end