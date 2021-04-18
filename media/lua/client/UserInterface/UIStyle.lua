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
	}
}

function UIStyle:initialise()
	Parent.initialise(self);
end

function UIStyle:new(o)
	o = o or {};
	MeowCore.extend(o, properties);
	setmetatable(o, self);
	self.__index = self;
	return o;
end


MeowCore.Client.UserInterface.UIStyle = UIStyle;
