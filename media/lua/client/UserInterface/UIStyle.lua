require "MeowCore";

MeowCore:namespace("Client/UserInterface");

local Color = MeowCore:require("Shared/Types/Color");

local UIStyle = {
	__type = "UIStyle"
};

local properties = {
	background = Color.red(),
	border = {
		all = {
			width = 0,
			color = Color.transparent()
		}
	},
	color = Color.white(),
	font = UIFont.Small,
	hover = {}
}

function UIStyle:initialise()
	Parent.initialise(self);
end

function UIStyle:new(o)
	o = o or {};
	o = MeowCore.extend({}, properties, o);
	setmetatable(o, self);
	self.__index = self;
	return o;
end


MeowCore.Client.UserInterface.UIStyle = UIStyle;
