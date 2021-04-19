require "MeowCore";

MeowCore:namespace("Shared/Core");
local INIUtils = MeowCore:require("Shared/Utils/INIUtils");

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
	local cfg = INIUtils.INIToTable(self.modid, self.filename);
	if(table.isEmpty(cfg)) then
		cfg = {};
	end
	self.cfg = MeowCore.extend({}, self.defaultConfig, cfg);
end

function Config:save()
	if(self.cfg == nil) then return false end
	INIUtils.TableToINI(self.modid, self.filename, self.cfg);
	return true;
end

function Config:initialise()
	self:load();
	self:save();
end


MeowCore.Shared.Core.Config = Config;
