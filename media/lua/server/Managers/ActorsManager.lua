require "MeowCore";

local Collection = MeowCore.require("Shared/Types/Collection")

local ActorsManager = MeowCore.class(
	"Server/Managers/ActorsManager", {
		actors = Collection:new()
	}
);

function ActorsManager:registerActor(actor)
	if(self.actors:get(actor.uuid)) then
		-- TODO: Error handling
		return;
	end
	self.actors:put(actor.uuid, actor);
end

function ActorsManager:getActorByUUID(uuid)
	return self.actors:get(uuid);
end
