require "MeowCore";

local INIUtils = MeowCore.require("Shared/Utils/INIUtils");

local Config = MeowCore.class(
	"Shared/Core/Config",
	{ filename="cfg.ini", cfg=nil, modid=nil, defaultConfig=nil }
);

local DS = INIUtils.DIR_SEP;


function Config:constructor_string_table(modid, defaultConfig)

	self.modid = modid;
	self.defaultConfig = defaultConfig;

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
