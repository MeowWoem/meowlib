require "MeowCore";

local MeowServer;

local ActorsManager = MeowCore.require('Server/Managers/ActorsManager');
local ActorsGroupsManager = MeowCore.require('Server/Managers/ActorsGroupsManager');
local PlayerActor = MeowCore.require("Shared/Actors/PlayerActor");
local ActorsGroup = MeowCore.require("Shared/Actors/ActorsGroup");

-- ###################################
-- Vanilla Server Side Events Handling
-- ###################################

--[[-----------------------------------------------------
	OnGameBoot
    #################
	Is called when the game/server is started or
	when mods are reloaded while the game is started.
-----------------------------------------------------]]--
local function OnGameBoot() end
Events.OnGameBoot.Add(OnGameBoot)

--[[-----------------------------------------------------
	OnGameTimeLoaded
    #################
-----------------------------------------------------]]--
local function OnGameTimeLoaded()
	MeowServer = MeowCore.require("Server/MeowServer");
	MeowServer.actorManager = ActorsManager:new();
	MeowServer.groupManager = ActorsGroupsManager:new();
end
Events.OnGameTimeLoaded.Add(OnGameTimeLoaded)

--[[-----------------------------------------------------
	OnGameStart
    #################
	Called when a new game is started, or loading of a save is finished.
-----------------------------------------------------]]--
local function OnGameStart() end
Events.OnGameStart.Add(OnGameStart)

--[[-----------------------------------------------------
	OnSave
    #################
	Triggered during the game's saving process.
-----------------------------------------------------]]--
local function OnSave() end
Events.OnSave.Add(OnSave)

--[[-----------------------------------------------------
	OnTick
    #################
	Called every tick, try to not use this one, use EveryTenMinutes instead because it can create a lot of frame loss/garbage collection.
-----------------------------------------------------]]--
local function OnTick() end
Events.OnTick.Add(OnTick)

--[[-----------------------------------------------------
	LoadGridsquare
    #################
	Called when a grid square is loaded
-----------------------------------------------------]]--
local function LoadGridsquare() end
Events.LoadGridsquare.Add(LoadGridsquare)

--[[-----------------------------------------------------
	OnCreatePlayer
    #################
	Triggered when a player is created.
-----------------------------------------------------]]--
local function OnCreatePlayer(playerNum)
	IsoPlayer.setCoopPVP(true);
	local actor = PlayerActor:new(playerNum);
	MeowServer.actorManager:registerActor(actor);
end
Events.OnCreatePlayer.Add(OnCreatePlayer)

--[[-----------------------------------------------------
	OnPlayerUpdate
    #################
	Called when IsoPlayer updates.
-----------------------------------------------------]]--
local function OnPlayerUpdate(isoPlayer) end
Events.OnPlayerUpdate.Add(OnPlayerUpdate)



--[[-----------------------------------------------------
	OnWeaponHitCharacter
    #################
	Triggered when a IsoGameCharacter has been hit by a HandWeapon
-----------------------------------------------------]]--
local function OnWeaponHitCharacter(isoWielder, isoVictim, weapon, damage)
	Dump("HIT");
	if(instanceof(isoWielder, "IsoZombie") == false and instanceof(isoVictim, "IsoZombie") == false) then
		Dump("HIT Actor>Actor", isoWielder, isoVictim);
		--[[local wielder = CharacterManager:getCharFromIsoPlayer(isoWielder);
		local victim = CharacterManager:getCharFromIsoPlayer(isoVictim);
		victim.hitUpdate = true;
		victim.hitWielder = wielder;
		victim.lastHitTimestamp = getGametimeTimestamp();]]--
		isoVictim:setAvoidDamage(true);
		--return false;
	elseif(instanceof(isoWielder, "IsoZombie") == true and instanceof(isoVictim, "IsoZombie") == false) then
		Dump("HIT Zombie>Actor", isoWielder, isoVictim);
		--[[local victim = CharacterManager:getCharFromIsoPlayer(isoVictim);
		victim.hitUpdate = true;
		victim.hitWielder = nil;
		victim.lastHitTimestamp = getGametimeTimestamp();]]--
	end

end
Events.OnWeaponHitCharacter.Add(OnWeaponHitCharacter);
