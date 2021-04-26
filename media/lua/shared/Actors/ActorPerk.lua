require "MeowCore";

local ActorPerk = MeowCore.class(
	"Shared/Actors/ActorPerk", {
		key = '',
		name = '',
		perk = nil
	}
);

function ActorPerk:constructor_Perk(perk)
	self.perk = perk;
	self.key = perk:getClass():getName();
	self.name = perk:getName();
end
