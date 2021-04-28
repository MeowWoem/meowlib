require "MeowCore";
require "ISUI/ISUIElement";

local UIWindow = MeowCore.require("Client/UserInterface/UIWindow");
local UIButton = MeowCore.require("Client/UserInterface/UIButton");
local UIRichTextPanel = MeowCore.require("Client/UserInterface/UIRichTextPanel");
local Config = MeowCore.require("Shared/Core/Config");
local V2 = MeowCore.require("Shared/Math/Geometry/Vector2");
local V3 = MeowCore.require("Shared/Math/Geometry/Vector3");
local Rect2D = MeowCore.require("Shared/Math/Geometry/Rect2D");
local ActorPerksRegistry = MeowCore.require("Shared/Actors/ActorPerksRegistry");



local function test()
	local regitry = ActorPerksRegistry:new();
	local elm = UIWindow:new(1000, 250, 500, 500);
	elm:initialise();
	elm:addToUIManager();
	elm:setVisible(true);

	local btn = UIButton:new("Test");

	btn.tooltipText = "<H1>Test <LINE> <RESET>TEST <TEXT>TEST <META>TEST";
	btn:initialise();

	--btn:testTooltip();

	local v2 = V2:new(1, 2);
	local v22 = V2:new(3, 4);
	local v3 = V3:new(1, 2, 3);
	local v33 = V3:new(4, 5, 6);

	local perks = regitry.perks;



	Dump(tostring(MeowCore.MOD_WEARELEGEND), getModInfo('test'), getModInfo('wearelegends'));
	--Dump(V2.__varAddress, v2.__varAddress, v22.__varAddress);
	--Dump(V3.__varAddress, v3.__varAddress, v33.__varAddress);

	elm.bodyPanel:addChild(btn);

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


-- Events.OnMainMenuEnter.Add(test);
