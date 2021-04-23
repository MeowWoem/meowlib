require "Types/String";
require "Types/Table";
require "Math/Math";

local function __switchMissing() end

local function switch(value, cases)
	local case = cases[value] or cases.default or __switchMissing;
	return case(value);
end

function isctype(t, value, strict)
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

function typed(t, value, strict)
	strict = strict or false;
	if(isctype(t, value, strict)) then
		return value;
	else
		error("Expected " .. (strict and 'strict ' or '') .. t .. " but " .. ctype(value) .. " given!")
	end
end

function ccast(cast, obj)
	if(type(obj) == "table" and cinstanceof(cast, getmetatable(obj))) then
		return cast:new(obj);
	end
end

function cinstanceof (subject, super)
	super = tostring(super);
	local mt = getmetatable(subject);
	while true do
		if mt == nil then return false end
		if tostring(mt) == super then return true end
		mt = getmetatable(mt);
	end
end

function ctype(obj, strict)
	if(strict == nil) then
		strict = true;
	end
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
	elseif t == 'number' then
		if strict then
			t = math.floor(obj) == obj and 'integer' or 'float';
		else
			t = 'number';
		end
	end
	return t
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

local MeowClass = {};
MeowCore = {};

local _required = {};

function MeowCore.namespace(str, root)
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

function MeowCore.interface(classObj, interfaceName)
	local interface = MeowCore.require(interfaceName);
	if(interface ~= nil) then
		return MeowCore.extend(classObj, interface);
	else
		return nil;
		-- TODO : Error
	end
end

function MeowCore.class(typeName, properties, constructors)
	constructors = constructors or {};
	properties = properties or {};
	local derived = MeowClass:new();
	derived.__type = typeName;
	function derived:new(...)
		local args = {...};
		local signature = getTableTypeSignature(args);
		local props;
		if(constructors[signature]) then
			props = {};
		else
			props = args[0] or {};
		end

		if(props == properties) then
			props = MeowCore.extend({}, props);
		else
			props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
			-- Do a deep copy on  properties definition to ensure default objects references are not shared between instance
		end

		local o = MeowClass:new(props);
		setmetatable(o, self);
		self.__index = self;
		if(constructors[signature] and o[constructors[signature]]) then
			o[constructors[signature]](o, ...);
		elseif(o.constructor) then
			o:constructor(...);
		end
		return o;
	end

	function derived.getClass()
		return derived;
	end

	derived.__tostring = function(self)
		local old = derived.__tostring;
		local olds = MeowClass.__tostring;
		derived.__tostring = nil;
		local s = typeName .. " " .. tostring(self):sub(7);
		derived.__tostring = old;
		MeowClass.__tostring = olds;
		return s;
	end

	local c = derived:new(properties);
	c.__tostring = function(self)
		local old = c.__tostring;
		c.__tostring = nil;
		local s = tostring(self);
		c.__tostring = old;
		return s;
	end
	return c;
end

function MeowCore.derive(typeName, from, properties, constructors)
	constructors = constructors or {};
	properties = properties or {};

	local super = nil;
	if(type(from) == 'string') then
		super = MeowCore.require(from);
	elseif(from.__type ~= nil) then
		super = from;
	end
	if(super ~= nil) then
		local derived = super:new();
		derived.__type = typeName;
		derived.__super = super;

		function derived:super()
			return self.__super;
		end

		function derived:new(...)
			local args = {...};
			local signature = getTableTypeSignature(args);
			local props;
			if(constructors[signature]) then
				props = {};
			else
				props = args[0] or {};
			end
			if(props == properties) then
				props = MeowCore.extend({}, props);
			else
				props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
				-- Do a deep copy on  properties definition to ensure default objects references are not shared between instance
			end

			local o = super:new(props);
			setmetatable(o, self);
			self.__index = self;

			if(constructors[signature] and o[constructors[signature]]) then
				o[constructors[signature]](o, ...);
			elseif(o.constructor) then
				o:constructor(...);
			end
			return o;
		end

		derived.__tostring = function(self)
			local old = derived.__tostring;
			local olds = super.__tostring;
			derived.__tostring = nil;
			local s = derived.__type .. " " .. tostring(self):sub(#super.__type + 2);
			derived.__tostring = old;
			super.__tostring = olds;
			return s;
		end

		local c = derived:new(properties);
		c.__tostring = function(self)
			local old = c.__tostring;
			local olds = super.__tostring;
			c.__tostring = nil;
			local s = derived.__type .. " " .. tostring(self):sub(#super.__type + 2);
			c.__tostring = old;
			super.__tostring = olds;
			return s;
		end
		return c;
	end
end

function MeowCore.require(str)
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
			if (ctype(main[k]) == 'table' and ctype(v) == 'table') then
				main[k] = MeowCore.extend({}, main[k], v)
			else
				main[k] = v
			end
		end
	end
	return main;
end


MeowClass.__type = 'MeowClass';
MeowClass.__super = nil;

function MeowClass:new(props)
	props = props or {};
	local o = MeowCore.extend({}, props);
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function MeowClass.getClass()
	return MeowClass;
end

function MeowClass:getClassName()
	return self.__type;
end

function MeowClass:super()
	return self.__super;
end

function MeowClass:hasSuper()
	return self.__super ~= nil;
end

local function _dump(o, lvl)
	local strIndent = '|  ';
	for _=1,lvl do
		strIndent = strIndent ..  '   ';
	end
	if type(o) == 'table' then
		local s = strIndent .. '{ \n';
		for k,v in pairs(o) do
			if lvl >= 256 then
				return (s .. strIndent ..  '   ' .. '\n... Max depth 256\n} ');
			end
			if(v == o) then
				s = s .. strIndent ..  '   ' .. '['..k..'] = ' .. tostring(v):gsub("table ", ctype(v) .. ':') .. ' (Recursive),\n';
			else
				if type(k) ~= 'number' then k = '"'..k..'"' end
				s = s .. strIndent ..  '   ' .. '['..k..'] = ' .. _dump(v, lvl + 1) .. ',\n';
			end
		end
		return (s .. strIndent .. '} ');
	else
		return (tostring(o));
	end
end

function Dump(...)
	local args = {...};
	local str = '';
	local l = table.length(args);
	for i, v in ipairs(args) do
		str = str .. '|-> ' .. _dump(v, 0);
		if(i < l) then str = str ..'\n' end
	end
	print("\n-------\n| [DUMP]\n" .. str .. '\n-------\n' .. debugstacktrace(nil, 2, 1));
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
