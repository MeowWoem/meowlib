require "MeowCore";

local Style = MeowCore:require("Client/UserInterface/UIStyle");
local Color = MeowCore:require("Shared/Types/Color");


local Theme = {
	UIButton = Style:new({
		background = Color.black(),
		color = Color.white(),
		font = UIFont.Small,
		border = {
			all = {
				width = 1,
				color = Color:new(0.7, 0.7, 0.7, 0.8)
			}
		},
		hover = {
			background = Color:new(0.3, 0.3, 0.3)
		}
	})
};

MeowCore.Client.Theme = Theme;
