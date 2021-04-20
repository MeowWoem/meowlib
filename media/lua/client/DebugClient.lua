require "MeowCore";

local UIPanel = MeowCore:require("Client/UserInterface/UIPanel");
local UIComponent = MeowCore:require("Client/UserInterface/UIComponent");
local UIButton = MeowCore:require("Client/UserInterface/UIButton");
local Config = MeowCore:require("Shared/Core/Config");

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
	btn:initialise();
	elm:addChild(btn);

	local cfg = Config:new("meowlib", {
		testTable = {
			testInt = 1,
			testStr = "a",
			testBool = true,
		},
		testTableHaha = {
			testInt = 2,
			testStr = "B",
			testBool = false,
			Hoho = {
				testFloat = 3.5,
				testStr = "c",
			}
		}
	});

	cfg:initialise();
end

Events.OnMainMenuEnter.Add(test);
