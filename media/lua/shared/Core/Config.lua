require "MeowCore";

MeowCore.namespace("Shared/Core");
local INIUtils = MeowCore.require("Shared/Utils/INIUtils");

local Config = {};

local DS = INIUtils.DIR_SEP;


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
	local cfg = INIUtils.INIToTable(self.modid, "config" .. DS .. self.filename);
	if(table.isEmpty(cfg)) then
		cfg = {};
	end
	self.cfg = MeowCore.extend({}, self.defaultConfig, cfg);
end

function Config:save()
	if(self.cfg == nil) then return false end
	INIUtils.TableToINI(self.modid, "config" .. DS .. self.filename, self.cfg);
	return true;
end

function Config:initialise()
	self:load();
	self:save();
end


MeowCore.Shared.Core.Config = Config;
