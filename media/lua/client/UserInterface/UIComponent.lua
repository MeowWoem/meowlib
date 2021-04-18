require "MeowCore";
require "ISUI/ISUIElement"

MeowCore:namespace("Client/UserInterface");

local UIStyle = MeowCore:require("Client/UserInterface/UIStyle");

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
	o.style = UIStyle:new();
	return o;
end

function UIComponent:prerender()
	--self:drawText("You must override UIComponent prerender method!", 0, 0, 0.8, 0, 0, 1, UIFont.Medium);
	local style = self.style;
	if style.background then
		self:drawRectStatic(0, 0, self.width, self.height, style.background.a, style.background.r, style.background.g, style.background.b);
		--self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	end
end

MeowCore.Client.UserInterface.UIComponent = UIComponent;
