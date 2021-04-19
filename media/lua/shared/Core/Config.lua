require "MeowCore";

MeowCore:namespace("Shared/Core");

local __FILE_SEP__ = getFileSeparator();
local Config = {};

local function toINI(modid, filename, content, fd, parentCat, fdTypeMap)
	if(fd == nil) then
		fd = getFileWriter(modid .. __FILE_SEP__ .. filename, true, false);
	end
	if(fdTypeMap == nil) then
		fdTypeMap = getFileWriter(modid .. __FILE_SEP__ .. filename .. ".typemap", true, false);
	end

  if not fd then return false end;
  local category = "";
	for catK, catV in pairs(content) do
		if parentCat then
      category = parentCat.."/"..catK;
		else
			category = catK;
		end
		fd:write("["..category.."]\n");
		fdTypeMap:write("["..category.."]\n");

		for k,v in pairs(catV) do
			if type(v) == "table" then
				local categoryTable = {};
				categoryTable[k] = v;
				toINI(modid, filename, categoryTable, fd, category, fdTypeMap);
			else
				fd:write(tostring(k).."="..tostring(v).."\n");
				fdTypeMap:write(tostring(k).."="..type(v).."\n");
			end
		end
	end
  fd:close();
  fdTypeMap:close();
end

local function fromINI(modid, filename)
	local retVal = {};
	local retTypes = {};
	local rvptr = retVal;
	local f = getFileReader(modid .. __FILE_SEP__ .. filename, false);
	local f2 = getModFileReader(modid, "media".. __FILE_SEP__ ..".typemaps" .. __FILE_SEP__ .. filename .. ".typemap", false);
	if not f or not f2 then return retVal end;

	local line = "1";
	local line2 = "1";
	local currentCat = "unknown";

	while line2 do
		line2 = f2:readLine();
		if line2 then
			if luautils.stringStarts(line2, "[") then
				currentCat = string.match(line2, "[a-zA-Z0-9/]+");
			else
				local kv = string.split(line2, "=");
				retTypes[currentCat .. "/" .. kv[1]] = kv[2];
			end
		end
	end

	while line do
		line = f:readLine();
		if line then
			if luautils.stringStarts(line, "[") then
				currentCat = string.match(line, "[a-zA-Z0-9/]+");
				rvptr = retVal;
				for _, cat in ipairs(string.split(currentCat, "/")) do
					if not rvptr[cat] then rvptr[cat] = {} end
					rvptr = rvptr[cat];
				end
			else
				local kv = string.split(line, "=");
        local vtype = retTypes[currentCat .. "/" .. kv[1]];
        local v = kv[2];
        if(vtype == "number") then
          v = tonumber(v);
        elseif(vtype == "boolean") then
          v = v == "true";
        end

				rvptr[kv[1]] = v;
			end
		end
	end
	return retVal;
end

function Config:new(modid, defaultConfig)
	local o = {};
	o.__type = "Config";
	setmetatable(o, self);
	self.__index = self;

	o.modid = modid;
	o.defaultConfig = defaultConfig;
	o.filename = "cfg.ini";
	o.cfg = nil;
	return o;
end

function Config:load()
	local cfg = fromINI(self.modid, self.filename);
	if(table.isEmpty(cfg)) then
		cfg = {};
	end
	self.cfg = MeowCore.extend({}, self.defaultConfig, cfg);
end

function Config:save()
	if(self.cfg == nil) then return false end
	toINI(self.modid, self.filename, self.cfg);
	return true;
end

function Config:initialise()
	self:load();
	self:save();
end


MeowCore.Shared.Core.Config = Config;
