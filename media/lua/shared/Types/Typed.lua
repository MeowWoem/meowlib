
local function ctype(obj, strict)
	if(strict == nil) then
		strict = true;
	end
	local t = type(obj)
	if t == 'table' then
		local mt = getmetatable(obj)
		if mt and mt.__type then
			if type(mt.__type) == 'string' then
				t = tostring(mt.__type)
			else
				pcall(function()
					t = tostring(mt:__type())
				end)
			end
		end
	elseif t == 'userdata' then
		if(obj.getClass) then
			local str = obj:getClass():getName();
			local i = str:find('%$');
			if(i) then
				t = str:sub(i + 1);
			else
				t = str;
			end
		else
			t = tostring(obj):split(" ")[1];
		end
	elseif t == 'number' then
		if strict then
			t = math.floor(obj) == obj and 'integer' or 'float';
		else
			t = 'number';
		end
	end
	return t
end


local function isctype(t, value, strict)
	strict = strict or false;
	if(t == 'number' and strict) then error("You can't use number type with strict comparaison"); end
	local tv = ctype(value);
	return (
		tv == t or (
			(t == 'number' or t == 'float') and
			((strict == false and tv == 'integer') or tv == 'float')
		)
	);
end

local function typed(t, value, strict)
	strict = strict or false;
	if(isctype(t, value, strict)) then
		return value;
	else
		error("Expected " .. (strict and 'strict ' or '') .. t .. " but " .. ctype(value) .. " given!")
	end
end

local function cinstanceof (subject, super)
	super = tostring(super);
	local mt = getmetatable(subject);
	while true do
		if mt == nil then return false end
		if tostring(mt) == super then return true end
		mt = getmetatable(mt);
	end
end

local function ccast(cast, obj)
	if(type(obj) == "table" and cinstanceof(cast, getmetatable(obj))) then
		return cast:new(obj);
	end
end

local function getTableTypeSignature(tbl, strict)
	if(strict == nil) then
		strict = false;
	end
	local signature = '';
	local l = #tbl;
	for i, v in ipairs(tbl) do
		signature = signature .. ctype(v, strict) .. (i == l and '' or ',');
	end
	return signature;
end

local _module = {
	isctype = isctype,
	typed = typed,
	ccast = ccast,
	cinstanceof = cinstanceof,
	ctype = ctype,
	getTableTypeSignature = getTableTypeSignature
};

function _module:get(str)
	local gets = luautils.split(str, ',');
	local r = {};
	for _,v in ipairs(gets) do
		print(self[v:trim()]);
		table.insert(r, self[v:trim()]);
	end
	return unpack(r);
end

return _module;
