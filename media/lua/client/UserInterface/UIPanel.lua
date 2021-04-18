require "MeowCore";

MeowCore:namespace("Client/UserInterface");
local UIComponent = MeowCore:require("Client/UserInterface/UIComponent");

local Parent = UIComponent;

local UIPanel = Parent:derive("UIPanel");

function UIPanel:initialise()
	Parent.initialise(self);
end

function UIPanel:new(x, y, width, height)
	local o = Parent:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
    o.moveWithMouse = false;
	return o;
end

function UIPanel:prerender()
	Parent.prerender(self);
	self:drawText("UI PANEL", 0, 0, .5, .3, .3, 1, UIFont.Medium);
end

function UIPanel:close()
	self:setVisible(false);
end

MeowCore.Client.UserInterface.UIPanel = UIPanel;
