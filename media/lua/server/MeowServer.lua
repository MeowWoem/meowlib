require "MeowCore";


local MeowServer = MeowCore.class("Server/MeowServer");

MeowServer.actorManager = nil;
MeowServer.groupManager = nil;

function MeowServer.getModData()
	local md;
	if(isServer() == true) then -- Not used in B41 IWBMS.
		md = getServerModData();
	else
		md = getGameTime():getModData();
		md.__meowServer = md.__meowServer or {};
		md = md.__meowServer;
	end
	return md;
end
