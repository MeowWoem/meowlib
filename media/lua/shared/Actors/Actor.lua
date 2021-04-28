require "MeowCore";


local Actor = MeowCore.class(
	"Shared/Actors/Actor", {
		id = 1,
		uuid = nil,
		isoObj = nil,
		isPlayer = false,
	}
);

function Actor:constructor()
	self.uuid = MeowCore.uuid();
end

function Actor:constructor_IsoGameCharacter(iso)
	self.isoObj = iso;
end

function Actor:constructor_IsoLivingCharacter(iso)
	self:constructor_IsoGameCharacter(iso);
end

function Actor:constructor_IsoPlayer(iso)
	self:constructor_IsoGameCharacter(iso);
	self.id = iso:getPlayerNum();
	self.isPlayer = true;
end

function Actor:constructor_IsoPlayer_boolean(iso, isPlayer)
	self:constructor_IsoGameCharacter(iso);
	self.id = iso:getPlayerNum();
	self.isPlayer = isPlayer;
end

function Actor:constructor_int(playerNum)
	self:constructor_IsoPlayer(getSpecificPlayer(playerNum));
end

function Actor:constructor_IsoZombie(iso)
	self:constructor_IsoGameCharacter(iso);
end
