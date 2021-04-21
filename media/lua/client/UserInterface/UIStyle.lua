require "MeowCore";

MeowCore.namespace("Client/UserInterface");

local Color = MeowCore.require("Shared/Types/Color");

local UIStyle = {
	__type = "UIStyle"
};

local properties = {
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
	hover = {},
	active = {}
}


function UIStyle:new(o)
	o = o or {};
	o = MeowCore.extend({}, DeepCopyRecursive(properties), o);
	setmetatable(o, self);
	self.__index = self;
	return o;
end


MeowCore.Client.UserInterface.UIStyle = UIStyle;
