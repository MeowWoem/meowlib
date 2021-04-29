require "MeowCore";

local ActorsGroupsManager = MeowCore.class(
	"Server/Managers/ActorsGroupsManager", {
		groups = {}
	}
);

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
