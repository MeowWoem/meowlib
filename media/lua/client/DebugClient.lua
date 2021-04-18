require "MeowCore";

local UIPanel = MeowCore:require("Client/UserInterface/UIPanel");

function test()

	local elm = UIPanel:new(500, 250, 500, 500);
	elm:initialise();
	elm:addToUIManager();
	elm:setVisible(true);

end
Events.OnGameStart.Add(test);
