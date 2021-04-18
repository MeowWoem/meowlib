require "MeowCore";
require "ISUI/ISUIElement"

MeowCore:namespace("Client/UserInterface");

local Parent = ISUIElement;
local UIComponent = Parent:derive("UIComponent");

function UIComponent:initialise()
	Parent.initialise(self);
end

function UIComponent:new(x, y, width, height)
	local o = Parent:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
	o.x = x;
	o.y = y;
    o.width = width;
	o.height = height;
	return o;
end

function UIComponent:prerender()
	self:drawText("You must override UIComponent prerender method!", 0, 0, 0.8, 0, 0, 1, UIFont.Medium);
end

MeowCore.Client.UserInterface.UIComponent = UIComponent;
