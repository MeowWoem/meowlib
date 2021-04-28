require "MeowCore";

local ActorsManager = MeowCore.require('Server/Managers/ActorsManager');

local MeowServer = MeowCore.class("Server/MeowServer");

MeowServer.actorManager = ActorsManager:new();

function MeowServer.getModData()
	local md;
	if(isServer() == true) then -- Not used in B41 IWBMS.
		md = getServerModData();
	else
		md = getSpecificPlayer(0):getModData();
		md.__meowServer = md.__meowServer or {};
		md = md.__meowServer;
	end
	return md;
end
