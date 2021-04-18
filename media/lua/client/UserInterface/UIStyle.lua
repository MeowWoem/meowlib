require "MeowCore";

MeowCore:namespace("Client/UserInterface");

local Color = MeowCore:require("Shared/Types/Color");

local UIStyle = {};

function UIStyle:initialise()
	Parent.initialise(self);
end

function UIStyle:new(o)
	local o = o or {};
	setmetatable(o, self);
	self.__index = self;
	o.background = Color:new();
	Dump(o.background);
	return o;
end


MeowCore.Client.UserInterface.UIStyle = UIStyle;
