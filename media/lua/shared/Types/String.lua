
function string:split(str, pattern)
  if(pattern == nil) then
    pattern = str;
    str = self;
  end
  local results = {}  -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pattern;
  local last_end = 1;
  local s, e, cap = str:find(fpat, 1);
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(results,cap);
    end
    last_end = e+1;
    s, e, cap = str:find(fpat, last_end);
  end
  if last_end <= #str then
    cap = str:sub(last_end);
    table.insert(results, cap);
  end
  return results;
end

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

function string:trim(str)
  if(str == nil) then str = self; end
  return str:match'^%s*(.*%S)' or ''
end
