function table_tostring(o)
   if type(o) == 'table' then
      local s = '{ '
      for k, v in pairs(o) do
         if type(k) ~= 'number' then k = '"' .. k .. '"' end
         s = s .. '[' .. k .. '] = ' .. table_tostring(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function table_cut(t, from, to)
   local from = from or 1
   local to = to or #t
   local length = #t
   -- remove values [1,from[
   for i = 1, from - 1 do
      table.remove(t, 1)
   end
   for i = to, #t - from do
      table.remove(t)
   end
end

function table_key_from_value(t, value)
   for k, v in pairs(t) do
      if v == value then return k end
   end
   return nil
end

function table_invert(t)
   local s = {}
   for k, v in pairs(t) do
      s[v] = k
   end
   return s
end

-- prints colored text to the terminal
-- format: &fText with color as hex value
-- for colors see https://tweaked.cc/module/colors.html
function print_color(terminal, msg)
   local s = "&0" .. msg .. "&0"
   local fields = {}
   local lastcolor = "0"
   local lastpos = 0

   for pos, clr in s:gmatch("()&(%x)") do
      table.insert(fields, { s:sub(lastpos + 2, pos - 1), lastcolor })
      lastcolor = clr
      lastpos = pos
   end
   terminal.setCursorPos(1, 1)
   for i = 2, #fields do
      terminal.setTextColor(2 ^ (tonumber(fields[i][2], 16)))
      print(table_tostring(terminal))
      terminal.write(fields[i][1])
   end
   -- reset color and create new line
   terminal.setTextColor(1)
   local x, _ = terminal.getCursorPos()
   terminal.setCursorPos(x + 1, 0)
end
