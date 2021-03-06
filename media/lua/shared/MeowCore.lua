require "Types/String";
require "Types/Table";
require "Math/Math";

local Typed = require("Types/Typed");

local isctype, typed, ccast, cinstanceof, ctype, getTableTypeSignature
	= Typed:get("isctype, typed, ccast, cinstanceof, ctype, getTableTypeSignature");


local function __switchMissing() end

local function switch(value, cases)
	local case = cases[value] or cases.default or __switchMissing;
	return case(value);
end

local MeowClass = {};

local activeModIDs = getActivatedMods()
local activeMods = {};
for i=1,activeModIDs:size() do
	local modID = activeModIDs:get(i-1)
	local modInfo = getModInfoByID(modID)
	activeMods[modID] = modInfo;
end

MeowCore = {
	Config = nil,
	activeMods = activeMods;
	switch = switch,
	Typed = function(str)
		local gets = luautils.split(str, ',');
		local r = {};
		for _,v in ipairs(gets) do
			table.insert(r, Typed[v:trim()]);
		end
		return unpack(r);
	end
};

function MeowCore.modIsActive(modid)
	return MeowCore.activeMods[modid] ~= nil;
end

MeowCore.MOD_WEARELEGEND = MeowCore.modIsActive('wearelegends');

local _required = {};

function MeowCore.uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and ZombRand(25, 0xf) or ZombRand(8, 0xb)
        return string.format('%x', v)
    end)
end

function MeowCore.default(val, typeName, defaultVal)
	if(val ~= nil and isctype(typeName, val)) then
		return val;
	elseif(defaultVal ~= nil) then
		return defaultVal;
	else
		switch(typeName, {
			integer = function() return 0 end,
			float = function() return 0 end,
			number = function() return 0 end,
			string = function() return '' end,
			boolean = function() return false end,
			table = function() return {} end,
			default = function() return nil end;
		});
	end
end

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
	local namespace = nil;

	if(typeName:find('/')) then
		local splitted = luautils.split(typeName, "/");
		typeName = splitted[#splitted];
		splitted[#splitted] = nil;
		local root = MeowCore;
		local obj = root;
		local lastObj = root;
		for _, v in ipairs(splitted) do
			obj = obj[v];
			if(obj == nil) then
				obj = {};
			end
			lastObj[v] = obj;
			lastObj = obj;
		end

		namespace = obj;
	end

	derived.__type = typeName;
	function derived:new(...)
		local args = {...};
		local signature = getTableTypeSignature(args);
		local autoSignature = signature:gsub(",", "_");
		local strictSignature = getTableTypeSignature(args, true);
		local autoStrictSignature = strictSignature:gsub(",", "_");
		local props;
		if(
			constructors[signature] or
			constructors[strictSignature] or
			self["constructor_" .. autoSignature] or
			self["constructor_" .. autoStrictSignature] or
			type(args[1]) ~= "table"
		) then
			props = {};
		else
			props = args[1] or {};
		end

		if(props == properties) then
			props = MeowCore.extend({}, props);
		else
			props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
			-- Do a deep copy on  properties definition to ensure default objects references are not shared between instance
		end

		local o = MeowClass:new(props);
		setmetatable(o, self);
		tostring(o);
		self.__index = self;
		if(constructors[strictSignature] and o[constructors[strictSignature]]) then
			o[constructors[strictSignature]](o, ...);
		elseif(o["constructor_" .. autoStrictSignature]) then
			o["constructor_" .. autoStrictSignature](o, ...);
		elseif(constructors[signature] and o[constructors[signature]]) then
			o[constructors[signature]](o, ...);
		elseif(o["constructor_" .. autoSignature]) then
			o["constructor_" .. autoSignature](o, ...);
		elseif(o.constructor) then
			o:constructor(...);
		end
		o.__tostring = function(self)
			local old = o.__tostring;
			o.__tostring = nil;
			local str = tostring(o);
			local i = str:find(' 0x');
			i = (not i) and str:find('@0x') or i;
			if(not i) then error("Use the method toString instead __tostring on " .. derived.__type) end
			str = str:sub(i)
			o.__varAddress = str;
			local s = derived.__type .. " " .. self.__varAddress;
			o.__tostring = old;
			return s;
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
		local str = tostring(self);
		local i = str:find(' 0x');
		i = (not i) and str:find('@0x') or i;
		if(not i) then error("Use the method toString instead __tostring on " .. derived.__type) end
		str = str:sub(i + 1)
		self.__varAddress = str:trim();
		local s = derived.__type .. ":Class@" .. self.__varAddress;
		derived.__tostring = old;
		MeowClass.__tostring = olds;
		return s;
	end

	local c = derived:new(properties);
	c.__tostring = function(self)
		local old = c.__tostring;
		c.__tostring = nil;
		local str = tostring(self);
		local i = str:find(' 0x');
		i = (not i) and str:find('@0x') or i;
		if(not i) then error("Use the method toString instead __tostring on " .. derived.__type) end
		str = str:sub(i + 1)
		self.__varAddress = str:trim();
		local s = self.toString and self:toString() or derived.__type .. ":Instance@" .. self.__varAddress;
		c.__tostring = old;
		return s;
	end
	if(namespace) then
		namespace[typeName] = c;
	end
	return c;
end

function MeowCore.derive(typeName, from, properties, constructors)
	constructors = constructors or {};
	properties = properties or {};
	local namespace = nil;

	if(typeName:find('/')) then
		local splitted = luautils.split(typeName, "/");
		typeName = splitted[#splitted];
		splitted[#splitted] = nil;
		local root = MeowCore;
		local obj = root;
		local lastObj = root;
		for _, v in ipairs(splitted) do
			obj = obj[v];
			if(obj == nil) then
				obj = {};
			end
			lastObj[v] = obj;
			lastObj = obj;
		end

		namespace = obj;
	end

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
			local autoSignature = signature:gsub(",", "_");
			local strictSignature = getTableTypeSignature(args, true);
			local autoStrictSignature = strictSignature:gsub(",", "_");
			local props;
			if(
				constructors[signature] or
				constructors[strictSignature] or
				self["constructor_" .. autoSignature] or
				self["constructor_" .. autoStrictSignature] or
				type(args[1]) ~= "table"
			) then
				props = {};
			else
				props = args[1] or {};
			end
			if(props == properties) then
				props = MeowCore.extend({}, props);
			else
				props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
				-- Do a deep copy on  properties definition to ensure default objects references are not shared between instance
			end
			local o = super:new(props);
			setmetatable(o, self);
			tostring(o);
			self.__index = self;
			if(constructors[strictSignature] and o[constructors[strictSignature]]) then
				o[constructors[strictSignature]](o, ...);
			elseif(o["constructor_" .. autoStrictSignature]) then
				o["constructor_" .. autoStrictSignature](o, ...);
			elseif(constructors[signature] and o[constructors[signature]]) then
				o[constructors[signature]](o, ...);
			elseif(o["constructor_" .. autoSignature]) then
				o["constructor_" .. autoSignature](o, ...);
			elseif(o.constructor) then
				o:constructor(...);
			end
			return o;
		end

		derived.__tostring = function(self)
			local old = derived.__tostring;
			local olds = super.__tostring;
			derived.__tostring = nil;
			super.__tostring = nil;
			local str = tostring(self);
			local i = str:find(' 0x');
			i = (not i) and str:find('@0x') or i;
			if(not i) then error("Use the method toString instead __tostring on " .. derived.__type) end
			str = str:sub(i+1)
			self.__varAddress = str:trim();
			local s = derived.__type .. ":Class@" .. self.__varAddress;
			derived.__tostring = old;
			super.__tostring = olds;
			return s;
		end

		local c = derived:new(properties);

		c.__tostring = function(self)
			local old = c.__tostring;
			local olds = super.__tostring;
			c.__tostring = nil;
			local str = tostring(self);
			local i = str:find(' 0x');
			i = (not i) and str:find('@0x') or i;
			if(not i) then error("Use the method toString instead __tostring on " .. derived.__type) end
			str = str:sub(i+1)
			self.__varAddress = str:trim();
			local s = self.Type ~= "ISUIBridge" and self.toString and self:toString() or
				derived.__type .. ":Instance@" .. self.__varAddress;
			c.__tostring = old;
			super.__tostring = olds;
			return s;
		end
		if(namespace) then
			namespace[typeName] = c;
		end
		return c;
	end
end

function MeowCore.require(...)
	local args = {...};
	if(#args > 1) then
		local results = {};
		for _, v in ipairs(args) do
			table.insert(results, MeowCore.require(v));
		end
		return unpack(results);
	else
		local str = args[1];
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
			error("Module : " .. str .. " Not exists in client!");
			return nil;
		end
		return obj;

	end
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
				s = s .. strIndent ..  '   ' .. '['..tostring(k)..'] = ' .. tostring(v):gsub("table ", ctype(v) .. ':') .. ' (Recursive),\n';
			else
				if type(k) ~= 'number' then k = '"'..tostring(k)..'"' end
				s = s .. strIndent ..  '   ' .. '['..tostring(k)..'] = ' .. _dump(v, lvl + 1) .. ',\n';
			end
		end
		return (s .. strIndent .. '} ');
	else
		return (tostring(o));
	end
end
local redumpStr = '';
function ReDump()
	Dump(redumpStr);
end
function Dump(...)
	local args = {...};
	local str = '';
	local l = table.length(args);
	for i, v in ipairs(args) do
		str = str .. '|-> ' .. _dump(v, 0);
		if(i < l) then str = str ..'\n' end
	end
	local res = "\n-------\n| [DUMP]\n" .. str .. '\n-------\n' .. debugstacktrace(nil, 2, 1);
	redumpStr = redumpStr .. res;
	print(res);
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

local function OnGameBoot()

	local Config = MeowCore.require("Shared/Core/Config");
	MeowCore.Config = Config:new("meowlib", {
		Debug = {
			enabled = true
		}
	});

	MeowCore.Config:initialise();
end
Events.OnGameBoot.Add(OnGameBoot)
