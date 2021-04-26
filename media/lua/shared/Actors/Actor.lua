require "MeowCore";


local Actor = MeowCore.class(
	"Shared/Actors/Actor", {
		isoObj = nil
	}
);

function Actor:constructor_IsoGameCharacter(iso)
	self.isoObj = iso;
end

function Actor:constructor_IsoLivingCharacter(iso)
	self:constructor_IsoGameCharacter(iso);
end

function Actor:constructor_IsoPlayer(iso)
	self:constructor_IsoGameCharacter(iso);
end

function Actor:constructor_IsoZombie(iso)
	self:constructor_IsoGameCharacter(iso);
end
