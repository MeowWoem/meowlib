require "MeowCore";


local Color = MeowCore.require("Shared/Types/Color");

local UIStyle = MeowCore.class(
	"Client/UserInterface/UIStyle", {
		background = Color.transparent(),
		color = Color.white(),
		font = UIFont.Small,
		boxSizing = "border-box",
		textureColor = Color.white(),
		border = {
			all = {
				width = 0,
				color = Color.transparent()
			}
		},
		margin = {
			top=0,
			right=0,
			bottom=0,
			left=0,
		},
		hover = {},
		active = {}
	}
);
