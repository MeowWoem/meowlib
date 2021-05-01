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

function ActorsManager:getActorByIso(iso)
  local md = iso:getModData();
	if not md.uuid then return nil end
	return self:getActorByUUID(md.uuid);
end

function ActorsManager:getActorByUUID(uuid)
	return self.actors:get(uuid);
end

function ActorsManager:getPlayerByNum(num)

	for _,v in pairs(self.actors:all()) do
		if v.isPlayer and v.id == num then
			return v;
		end
	end
end
