require "MeowCore";

local UIPanel = MeowCore:require("Client/UserInterface/UIPanel");
local UIComponent = MeowCore:require("Client/UserInterface/UIComponent");
local UIButton = MeowCore:require("Client/UserInterface/UIButton");

function test()

	local elm = UIPanel:new({
		x = 500,
		y = 250,
		width = 500,
		height = 500
	});
	elm:initialise();
	elm:addToUIManager();
	elm:setVisible(true);

	local btn = UIButton:new({
		title = "Button"
	});
	elm:addChild(btn);
end

Events.OnMainMenuEnter.Add(test);
