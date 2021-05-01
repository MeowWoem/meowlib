require "MeowCore";

local ActorsGroup = MeowCore.require("Shared/Actors/ActorsGroup");

local ActorsGroupsManager = MeowCore.class(
	"Server/Managers/ActorsGroupsManager", {
		groups = {}
	}
);

function ActorsGroupsManager:loadModData()
	self.modData = MeowCore.require("Server/MeowServer").getModData();

	for i, group in ipairs(self.modData.groups or {}) do
		self.modData.groups[i] = ActorsGroup:new(group);
	end

	self.groups = self.modData.groups or self.groups;
	self:updateModData();
end

function ActorsGroupsManager:updateModData()
	self.modData.groups = self.groups;
end

function ActorsGroupsManager:constructor()
	self:loadModData();
end

function ActorsGroupsManager:constructor_boolean(load)
	if (load) then
		self:loadModData();
	end
end

function ActorsGroupsManager:createGroup(leader)
	local group = MeowCore.require("Shared/Actors/ActorsGroup"):new(leader);
	self.groups[group.uuid] = group;
	Dump(self.modData.groups[group.uuid]);
	return group;
end

function ActorsGroupsManager:registerGroup(group)
	if(self.groups[group.uuid]) then
		-- TODO: Error handling
		return;
	end
	self.groups[group.uuid] = group;
end

function ActorsGroupsManager:getGroupByUUID(uuid)
	return self.groups[uuid];
end
