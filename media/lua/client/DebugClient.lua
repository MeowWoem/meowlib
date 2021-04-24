require "MeowCore";
require "ISUI/ISUIElement";

local UIPanel = MeowCore.require("Client/UserInterface/UIPanel");
local UIButton = MeowCore.require("Client/UserInterface/UIButton");
local Config = MeowCore.require("Shared/Core/Config");


local function test()
	local elm = UIPanel:new(1000, 250, 500, 500);
	elm:initialise();
	elm:addToUIManager();
	elm:setVisible(true);

	local btn = UIButton:new("Test");
	btn:initialise();

	--btn:testTooltip();



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
