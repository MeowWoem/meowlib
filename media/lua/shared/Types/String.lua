function string:findLast(haystack, needle)

	if(needle == nil) then
		needle = haystack;
      	haystack = self;
    end

    local i=haystack:match(".*"..needle.."()");
    if i==nil then return nil else return i-1 end
end

function string:endsWith(str, endsWith)
  if(endsWith == nil) then
    endsWith = str;
    str = self;
  end
   return endsWith == '' or string.sub(str,-string.len(endsWith)) == endsWith;
end

function string:getAllAfterLast(haystack, needle)

	if(needle == nil) then
		needle = haystack;
		haystack = self;
	end

	local i = haystack:findLast(needle);
	if(i == nil) then return haystack end

	local str = haystack:sub(i);
	if(str:endsWith(".lua")) then
		str = str:sub(1, -4);
	end
	return str;
end
