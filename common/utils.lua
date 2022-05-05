function table_tostring(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. table_tostring(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function table_cut(table, from, to)
   local from = from or 1
   local to = to or #table
   local length = #table
   -- remove values [1,from[
   for i = 1, from - 1 do
      table.remove(1)
   end
   for i = to, #table - from do
      table.remove()
   end
end