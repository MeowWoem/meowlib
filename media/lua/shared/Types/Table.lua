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
	return #o == 0;
end
