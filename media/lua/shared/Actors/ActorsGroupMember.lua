require "MeowCore";


local ActorsGroupMember = MeowCore.class(
	"Shared/Actors/ActorsGroupMember", {
		uuid = nil,
		isLeader = false,
		isPlayer = false
	}
);

function ActorsGroupMember:constructor_string(uuid)

	self.uuid = uuid;

	local actor = self:getActor();
	self.isPlayer = actor.isPlayer;

end

function ActorsGroupMember:constructor_PlayerActor(player)
	self.uuid = player.uuid;
	self.isPlayer = true;
end

function ActorsGroupMember:getActor()
	return MeowCore.require("Server/MeowServer").actorManager:getActorByUUID(self.uuid);
end
