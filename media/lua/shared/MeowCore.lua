MeowCore = {};

function Dump(o)
   if type(o) == 'table' then
      local s = '{ \n';
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ',';
      end
      print(s .. '\n} ');
   else
      print(tostring(o));
   end
end
