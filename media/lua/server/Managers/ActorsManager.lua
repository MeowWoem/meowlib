require "MeowCore";

local Collection = MeowCore.require("Shared/Types/Collection")

local ActorsManager = MeowCore.class(
	"Server/Managers/ActorsManager", {
		actors = Collection:new()
	}
);

function ActorsManager:registerActor(actor)

end
