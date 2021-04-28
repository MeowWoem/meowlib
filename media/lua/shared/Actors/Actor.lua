require "MeowCore";

local EventsManager = MeowCore.require("Shared/Events/EventsManager");
local Vector2 = MeowCore.require("Shared/Math/Geometry/Vector2");
local Vector3 = MeowCore.require("Shared/Math/Geometry/Vector3");
local _eventsManager = EventsManager:new();

local Actor = MeowCore.class(
	"Shared/Actors/Actor", {
		id = 1,
		isoObj = nil,
		isPlayer = false,
		uuid = nil,
		isDead = false,
		modData = nil,
		lastSquare = nil
	}
);

function Actor:loadModData()
	if(self.isoObj == nil) then return end
	self.modData = self.isoObj:getModData();
	self.modData.meow = self.modData.meow or {};
	self.uuid = self.modData.meow.uuid or MeowCore.uuid();
	self.isDead = self.modData.meow.isDead or false;
	self.lastSquare = self.modData.meow.lastSquare or nil;
	self:updateModData();
end

function Actor:updateModData()
	self.modData.meow.isPlayer = self.isPlayer;
	self.modData.meow.uuid = self.uuid;
	self.modData.meow.isDead = self.isDead;
	self.modData.meow.lastSquare = self.lastSquare;
end

function Actor:constructor()
	self:loadModData();
	self:onInit();
end

function Actor:constructor_IsoGameCharacter(iso)
	self.isoObj = iso;
	self:constructor();
end

function Actor:constructor_IsoLivingCharacter(iso)
	self:constructor_IsoGameCharacter(iso);
end

function Actor:constructor_IsoPlayer(iso)
	self.id = iso:getPlayerNum();
	self.isPlayer = true;
	self:constructor_IsoGameCharacter(iso);
end

function Actor:constructor_IsoPlayer_boolean(iso, isPlayer)
	self:constructor_IsoGameCharacter(iso);
	self.id = iso:getPlayerNum();
	self.isPlayer = isPlayer;
end

function Actor:constructor_integer(playerNum)
	self:constructor_IsoPlayer(getSpecificPlayer(playerNum));
end

function Actor:constructor_IsoZombie(iso)
	self:constructor_IsoGameCharacter(iso);
end

function Actor.on(event, callback)
	_eventsManager:addEventListener(event, callback);
end

function Actor:onInit()
	_eventsManager:trigger(self, 'init', {});
end

function Actor:onStart()
	_eventsManager:trigger(self, 'start', {});
end

function Actor:getInventory()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getInventory();
end

function Actor:getFullName()
	return self.isoObj:getFullName();
end

function Actor:getForname()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getForname();
end

function Actor:getSurname()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getSurname();
end

function Actor:getModData()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getModData();
end

function Actor:getDescriptor()
	if(self.isoObj == nil) then return false end
	return self.isoObj:getDescriptor();
end

function Actor:getCurrentSquare()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getCurrentSquare();
end


function Actor:getSquare()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getSquare();
end

function Actor:getX()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getX();
end

function Actor:getY()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getY();
end

function Actor:getZ()
	if(self.isoObj == nil) then return nil end
	return self.isoObj:getZ();
end

function Actor:getPosition()
	if(self.isoObj == nil) then return nil end
	return Vector3:new(self:getX(), self:getY(), self:getZ());
end

function Actor:getPosition2D()
	if(self.isoObj == nil) then return nil end
	return Vector2:new(self:getX(), self:getY());
end


function Actor:say(str)

	str = str:gsub("*", "{ASTERISK}");
	str = str:gsub("?", "{INTERROGATION}");
	str = str:gsub("%%", "{PERCENTAGE}");

	local replaceTokens = function(str)
		str = str:trim():gsub("{ASTERISK}", "*");
		str = str:trim():gsub("{INTERROGATION}", "?");
		str = str:trim():gsub("{PERCENTAGE}", "%%");
		return str;
	end

	local cmds = {
		"SHOUT",
		"WHISPER"
	}

	local startsWith = {};
	local saysNonOrdered = {};
	for _, cmd in pairs(cmds) do
		local searchCmd = true;

		local limit = 50;
		local i = 0;
		while searchCmd do
			local cmdStart = "<"..cmd..">";
			local cmdEnd = "</"..cmd..">";
			local st = str:find(cmdStart);
			local en = str:find(cmdEnd);
			if(i >= limit) then
				searchCmd = false;
			end

			if(st == nil or en == nil) then
				searchCmd = false;
			else
				local cmdStr = str:sub(st + #cmdStart, en - 1);

				if(st == 1) then
					table.insert(startsWith, {
							cmd = cmd,
							str = cmdStr
						});
				else
					table.insert(saysNonOrdered, {
							cmd = cmd,
							str = cmdStr
						});
				end
				str = str:gsub(cmdStart..cmdStr..cmdEnd, "<BREAKCMD>", 1);

			end
			i = i + 1;
		end
	end
	local sayBreak = str:split("<BREAKCMD>");

	for i, say in ipairs(sayBreak) do

		local trimmedSay = replaceTokens(say);
		if(trimmedSay ~= "") then
			self.isoObj:Say(trimmedSay);
		end
		local sayCmd = saysNonOrdered[i];

		if(sayCmd ~= nil) then
			local trimmedSayCmd = replaceTokens(sayCmd.str);

			if(trimmedSayCmd ~= "") then
				if(sayCmd.cmd == "SHOUT") then
					self.isoObj:SayShout(trimmedSayCmd);
				elseif(sayCmd.cmd == "WHISPER") then
					self.isoObj:SayWhisper(trimmedSayCmd);
				end

			end
		end
	end

end
