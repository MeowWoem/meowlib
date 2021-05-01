require "MeowCore";

local Style = MeowCore.require("Client/UserInterface/UIStyle");
local Color = MeowCore.require("Shared/Types/Color");


local Theme = {
	UIPanel = Style:new({
		background = Color.blue(),
		color = Color.white(),
		font = UIFont.Small,
		border = {
			all = {
				width = 0,
				color = Color.transparent()
			}
		},
		hover = {}
	}),
	UIWindow = Style:new({
		background = Color.green(),
		color = Color.white(),
		font = UIFont.Small,
		border = {
			all = {
				width = 0,
				color = Color.transparent()
			}
		},
		hover = {}
	}),
	UITabPanel = Style:new({
		background = Color.red(),
		color = Color.white(),
		font = UIFont.Small,
		border = {
			all = {
				width = 0,
				color = Color.transparent()
			}
		},
		hover = {}
	}),
	UITooltip = Style:new({
		background = Color:new(0, 0, 0, 0.3),
		color = Color.white(),
		font = UIFont.Small,
		border = {
			all = {
				width = 2,
				color = Color:new(1, 1, 1, 0.1)
			}
		},
		hover = {}
	}),
	UIRichTextPanel = Style:new({
		background = Color.transparent(),
		color = Color.white(),
		font = UIFont.Small,
		border = {
			all = {
				width = 0,
				color = Color.transparent()
			}
		},
		margin = {
			top=10,
			right=10,
			bottom=10,
			left=20,
		},
		hover = {},
		richText = {
			H1 = {
				color = Color.white(),
				font = UIFont.Large
			},
			H2 = {
				color = Color.lightgray(),
				font = UIFont.Medium
			},
			TEXT = {
				color = Color.white(),
				font = UIFont.Small
			},
			META = {
				color = Color.silver(),
				font = UIFont.Small
			},
		}
	}),
	UIButton = Style:new({
		background = Color.black(),
		color = Color.white(),
		font = UIFont.Small,
		border = {
			all = {
				width = 1,
				color = Color:new(0.7, 0.7, 0.7, 1)
			}
		},
		hover = {
			background = Color:new(0.3, 0.3, 0.3)
		},
		active = {
			background = Color:new(0.15, 0.15, 0.15)
		}
	}),
	UIResizeWidget = Style:new({
		background = Color.red(),
		color = Color.white(),
		font = UIFont.Small,
		border = {
			all = {
				width = 1,
				color = Color:new(0.7, 0.7, 0.7, 1)
			}
		},
		hover = {
			background = Color:new(0, 1, 0.3)
		},
		active = {
			background = Color:new(0.15, 0.15, 0.15)
		}
	})
};

MeowCore.Client.Theme = Theme;
