require "MeowCore";

MeowCore:namespace("Client/UserInterface/Events");
local EventsManager = MeowCore:require("Shared/Events/EventsManager");

local UIComponentEventsManager = EventsManager:new();
UIComponentEventsManager.__type = "UIComponentEventsManager";

local properties = {
	events = {
		MouseDown = {},
		MouseDownOutside = {},
		MouseUp = {},
		MouseUpOutside = {},
		MouseMove = {},
		MouseMoveOutside = {},
		MouseWheel = {},
		RightMouseDown = {},
		RightMouseDownOutside = {},
		RightMouseUp = {},
		RightMouseUpOutside = {}
	}
}

function UIComponentEventsManager:new(props)
	props = props or {};
	props = MeowCore.extend({}, DeepCopyRecursive(properties), props);
	local o = EventsManager:new(props);
	setmetatable(o, self);
	self.__index = self;
	return o;
end


function UIComponentEventsManager:addEventListener(eventType, listener)
	EventsManager.addEventListener(self, eventType, listener);
end

function UIComponentEventsManager:removeEventListener(eventType, listener)
	EventsManager.removeEventListener(self, eventType, listener);
end

function UIComponentEventsManager:trigger(elm, eventType, eventData)
	EventsManager.trigger(self, elm, eventType, eventData);
end

MeowCore.Client.UserInterface.Events.UIComponentEventsManager = UIComponentEventsManager;
