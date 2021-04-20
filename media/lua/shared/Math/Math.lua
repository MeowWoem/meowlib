math.clamp = function(number, nmin, nmax)
	if(number < nmin) then number = nmin; end
	if(number > nmax) then number = nmax; end
	return number;
end
