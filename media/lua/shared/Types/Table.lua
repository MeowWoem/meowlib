function table.pack(...)
    return { n = select("#", ...); ... }
end

function table:isEmpty(o)
  if(o == nil) then o = self; end
	for _,_ in pairs(o) do
		return false
	end
	return true
end
