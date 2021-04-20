require "Types/String";
require "Types/Table";

function cinstanceof (subject, super)
	super = tostring(super);
	local mt = getmetatable(subject);
	while true do
		if mt == nil then return false end
		if tostring(mt) == super then return true end
		mt = getmetatable(mt);
	end
end

function ctype(obj)
	local t = type(obj)
	if t == 'table' or t == 'userdata' then
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
	end
	return t
end

MeowCore = {};

local _required = {};

function MeowCore:namespace(str, root)
	root = root or MeowCore;
	local obj = root;
	local lastObj = root;
	for _, v in ipairs(luautils.split(str, "/")) do
		obj = obj[v];
		if(obj == nil) then
			obj = {};
		end
		lastObj[v] = obj;
		lastObj = obj;
	end

	return obj;
end

function MeowCore:require(str)
	local path = str;
	local i, l = path:find("Client/");
	if(i == 1) then
		path = path:sub(i + l);
	else
		i, l = path:find("Shared/");
		if(i == 1) then
			path = path:sub(i + l);
		else
			i, l = path:find("Server/");
			if(i == 1) then
				path = path:sub(i + l);
			end
		end
	end



	if(_required[str] ~= true) then

		print("Require : " .. str);

		_required[str] = true;
		require (path);
	end
	local obj = MeowCore;

	for _, v in ipairs(luautils.split(str, "/")) do
		if(obj == nil) then
			return nil;
		end
		obj = obj[v];
	end

	if(obj == nil or obj == MeowCore) then
		print("Module : " .. str .. " Not exists in client!");
		return nil;
	end
	return obj;
end

function MeowCore.extend(main, ...)
	local args = table.pack(...);

	for i = 1, args.n do
		local table = args[i];
		for k, v in pairs(table) do
			if (type(main[k]) == 'table' and type(v) == 'table') then
				main[k] = MeowCore.extend({}, main[k], v)
			else
				main[k] = v
			end
		end
	end
	return main;
end


local function _dump(o)
	if type(o) == 'table' then
		local s = '{ \n';
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. _dump(v) .. ',';
		end
		return (s .. '\n} ');
	else
		return (tostring(o));
	end
end

function Dump(o)
	print(_dump(o));
end

function DeepCopy(obj)
	if type(obj) ~= 'table' then return obj end
	local res = setmetatable({}, getmetatable(obj))
	for k, v in pairs(obj) do res[DeepCopy(k)] = DeepCopy(v) end
	return res
end

function DeepCopyRecursive(obj, seen)
	-- Handle non-tables and previously-seen tables.
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end

	-- New table; mark it as seen and copy recursively.
	local s = seen or {}
	local res = {}
	s[obj] = res
	for k, v in pairs(obj) do res[DeepCopyRecursive(k, s)] = DeepCopyRecursive(v, s) end
	return setmetatable(res, getmetatable(obj))
end
