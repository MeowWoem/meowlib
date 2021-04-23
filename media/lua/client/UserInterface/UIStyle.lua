require "MeowCore";

MeowCore.namespace("Client/UserInterface");

local Color = MeowCore.require("Shared/Types/Color");

local UIStyle = MeowCore.class(
	"UIStyle", {
		background = Color.transparent(),
		border = {
			all = {
				width = 0,
				color = Color.transparent()
			}
		},
		color = Color.white(),
		font = UIFont.Small,
		boxSizing = "border-box",
		textureColor = Color.white(),
		hover = {},
		active = {}
	}
);

MeowCore.Client.UserInterface.UIStyle = UIStyle;
