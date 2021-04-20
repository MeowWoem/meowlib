require "MeowCore";

local UIPanel = MeowCore:require("Client/UserInterface/UIPanel");
local UIComponent = MeowCore:require("Client/UserInterface/UIComponent");
local UIButton = MeowCore:require("Client/UserInterface/UIButton");
local Config = MeowCore:require("Shared/Core/Config");
local Vector2 = MeowCore:require("Shared/Math/Geometry/Vector2");
local Vector3 = MeowCore:require("Shared/Math/Geometry/Vector3");

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

local v2 = Vector2:new(0, 5);
local v = Vector3:new(0, 5, 3);
Dump(ccast(Vector3, v2));
Dump(v);
Dump(ctype(v));
Dump(cinstanceof(Vector3, Vector2));
Dump(cinstanceof(Vector3, v2));
Dump(cinstanceof(v2, Vector3));
Dump(cinstanceof(v2, Vector2));
Dump(cinstanceof(v2, Config));

Events.OnMainMenuEnter.Add(test);
