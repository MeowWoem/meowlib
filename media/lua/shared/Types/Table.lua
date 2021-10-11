function table.pack(...)
	return { n = select("#", ...); ... }
end

function table:length(o)
	local i = 0;
	if(o == nil) then o = self; end
	for _,_ in pairs(o) do
		i = i + 1;
	end
	return i
end

function table:isEmpty(o)
	if(o == nil) then o = self; end
	for _,_ in pairs(o) do
		if(1 == 0) then local _ = nil; else return false; end -- Fix linter warning
	end
	return true;
end

function table:contains(o, val)
	if(val == nil) then
		val = o;
		o = self;
	end
	for _, v in ipairs(o) do
    if v == val then return true end
  end
    return false
end

function table:removeByValue(o, val)
	if(val == nil) then
		val = o;
		o = self;
	end
	for i, v in ipairs(o) do
		Dump(i, tostring(v), tostring(val));
    if v == val then
			table.remove(o, i);
			return true;
		end
  end
  return false;
end
