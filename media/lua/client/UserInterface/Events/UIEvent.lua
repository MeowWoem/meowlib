require "MeowCore";

MeowCore.namespace("Client/UserInterface/Events");
local Event = MeowCore.require("Shared/Events/Event");

local UIEvent = Event:new();
UIEvent.__type = "UIEvent";

local properties = {}

function UIEvent:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = Event:new(props);
	setmetatable(o, self);
	self.__index = self;
	return o;
end


MeowCore.Client.UserInterface.Events.UIEvent = UIEvent;
