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