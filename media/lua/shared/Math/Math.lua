math.clamp = function(number, nmin, nmax)
	if(number < nmin) then number = nmin; end
	if(number > nmax) then number = nmax; end
	return number;
end

math.round = function(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end
