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
		if(1 == 0) then else return false; end -- Fix linter warning
	end
	return true;
end
