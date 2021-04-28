require "MeowCore";


local PlayerActor = MeowCore.derive(
	"Shared/Actors/PlayerActor",
	"Shared/Actors/Actor"
);

function PlayerActor:constructor()
	if(not self.isPlayer) then
		error("Unable to init PlayerActor. Ensure you use the correct constructor");
		return;
	end
	PlayerActor:super().constructor(self);
end


function PlayerActor:constructor_IsoZombie() error("A IsoZombie is not a IsoPlayer"); end
