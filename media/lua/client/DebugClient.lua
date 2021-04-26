require "MeowCore";
require "ISUI/ISUIElement";

local UIWindow = MeowCore.require("Client/UserInterface/UIWindow");
local UIButton = MeowCore.require("Client/UserInterface/UIButton");
local UIRichTextPanel = MeowCore.require("Client/UserInterface/UIRichTextPanel");
local Config = MeowCore.require("Shared/Core/Config");
local V2 = MeowCore.require("Shared/Math/Geometry/Vector2");
local V3 = MeowCore.require("Shared/Math/Geometry/Vector3");
local Rect2D = MeowCore.require("Shared/Math/Geometry/Rect2D");


local function test()
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

	local perks = {};
	-- we start to fetch all our perks
	for i = 0, PerkFactory.PerkList:size() - 1 do
		local perk = PerkFactory.PerkList:get(i);
		-- we only add in our list the child perk
		-- here we just display the active skill, not the passive ones (they are in another tab)
		if perk:getParent() ~= Perks.None then
			-- we take the longest skill's name as width reference
			if not perks[perk:getParent()] then
				perks[perk:getParent()] = {};
			end
			table.insert(perks[perk:getParent()], perk);
		end
	end

	Dump(perks);
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


Events.OnMainMenuEnter.Add(test);
