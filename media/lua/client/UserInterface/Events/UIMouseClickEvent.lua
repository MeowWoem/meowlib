require "MeowCore";

MeowCore:namespace("Client/UserInterface/Events");
local UIEvent = MeowCore:require("Client/UserInterface/Events/UIEvent");

local UIMouseClickEvent = UIEvent:new();
UIMouseClickEvent.__type = "UIMouseClickEvent";

local properties = {
	x = 0, y = 0
}

function UIMouseClickEvent:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = UIEvent:new(props);
	setmetatable(o, self);
	self.__index = self;
	return o;
end


MeowCore.Client.UserInterface.Events.UIMouseClickEvent = UIMouseClickEvent;
