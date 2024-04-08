function clamp(val, min, max)
    if val < min then
        return min
    elseif val > max then
        return max
    else
        return val
    end
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' else k = '['..k..']' end
         s = s .. k .. ' = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
