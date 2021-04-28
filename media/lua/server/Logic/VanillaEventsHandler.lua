require "MeowCore";

local MeowServer = MeowCore.require("Server/MeowServer");
local PlayerActor = MeowCore.require("Shared/Actors/PlayerActor");

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
